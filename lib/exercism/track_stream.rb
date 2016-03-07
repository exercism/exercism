require 'will_paginate/array'

# TrackStream is an activity stream which has been filtered against the user's access list.
# Additionally, it can be narrowed down to a single exercise within a track.
class TrackStream
  attr_reader :user, :page, :track_id, :slug, :language
  attr_accessor :per_page
  def initialize(user, track_id, slug=nil, page=1)
    @user = user
    @track_id = track_id.to_s.downcase
    @slug = slug.downcase if !!slug
    @language = Language.of(track_id)
    @page = page.to_i
    @per_page = 50
  end

  def mark_as_read
    execute(mark_as_read_insert_sql)
    execute(mark_as_read_update_sql)
  end

  def first_unread_uuid
    row = execute(first_unread_uuid_sql).first
    row["uuid"] if !!row
  end

  def last_id
    row = execute(last_id_sql).first
    return 0 if !row
    row["id"].to_i
  end

  def title
    if slug.nil?
      language
    else
      [language, Problem.new(track_id, slug).name].join(" ")
    end
  end

  def exercises
    @exercises ||= query_exercises
  end

  def tracks
    @tracks ||= UserTrack.all_for(user)
  end

  def problems
    @problems ||= UserTrack.problems_for(user, track_id)
  end

  def pagination
    (1..current.total).to_a.paginate(page: page, per_page: per_page)
  end

  def current
    problems.find {|problem| problem.slug == slug } || tracks.find {|track| track.id == track_id } || UserTrack.new(track_id, 0, 0)
  end

  # This becomes unbearably slow if we do a left join on views to get the unread value
  # up front.
  # If performance is still a problem, remove the join on user and do a separate lookup
  # for that as well.
  def query_exercises
    exx = []
    ids = []
    exx_by_id = execute(exercises_sql).each_with_object({}) do |row, by_id|
      problem = Problem.new(row["language"], row["slug"])
      attrs = [
        row["id"].to_i,
        row["uuid"],
        problem,
        row["last_activity"],
        row["last_activity_at"],
        row["iteration_count"].to_i,
        row["username"],
        row["avatar_url"],
      ]
      ex = Stream::Exercise.new(*attrs)
      exx << ex

      ids << row["id"]
      by_id[row["id"]] = ex
    end

    viewed(ids).each do |id|
      exx_by_id[id].viewed!
    end

    comment_counts(ids).each do |id, count|
      exx_by_id[id].comment_count = count.to_i
    end

    exx
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def comment_counts(ids)
    return [] if ids.empty?

    execute(comment_counts_sql(ids)).map {|row| [row["id"], row["total"]]}
  end

  def viewed(ids)
    return [] if ids.empty?

    execute(viewed_sql(ids)).map {|row| row["id"]}
  end

  def viewed_sql(ids)
    <<-SQL
      SELECT ex.id
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE views.user_id=#{user.id}
        AND views.last_viewed_at > ex.last_activity_at
        AND ex.archived='f'
        AND ex.language='#{track_id}'
        AND ex.slug != 'hello-world'
        AND ex.iteration_count > 0
        AND ex.id IN (#{ids.join(',')})
    SQL
  end

  def comment_counts_sql(ids)
    <<-SQL
    SELECT s.user_exercise_id AS id, COUNT(c.id) AS total
    FROM submissions s
    INNER JOIN comments c
    ON c.submission_id=s.id
    WHERE s.user_exercise_id IN (#{ids.join(',')})
    GROUP BY s.user_exercise_id
    SQL
  end

  def last_id_sql
    <<-SQL
      SELECT
        ex.id
      FROM user_exercises ex
      INNER JOIN users u
        ON ex.user_id=u.id
      INNER JOIN acls
        ON ex.language=acls.language
        AND ex.slug=acls.slug
      WHERE acls.user_id=#{user.id}
        AND ex.language='#{track_id}'
        AND ex.slug=#{slug_param}
        AND ex.archived='f'
        AND ex.slug != 'hello-world'
        AND ex.iteration_count > 0
      ORDER BY ex.last_activity_at ASC
      LIMIT 1
    SQL
  end

  def first_unread_uuid_sql
    <<-SQL
      SELECT
        ex.key AS uuid
      FROM user_exercises ex
      INNER JOIN acls
        ON ex.language=acls.language
        AND ex.slug=acls.slug
      LEFT JOIN views
        ON acls.user_id=views.user_id
        AND ex.id=views.exercise_id
      WHERE acls.user_id=#{user.id}
        AND ex.language='#{track_id}'
        AND ex.slug=#{slug_param}
        AND ex.archived='f'
        AND ex.slug != 'hello-world'
        AND ex.iteration_count > 0
        AND (
          views.id IS NULL
          OR
          ex.last_activity_at > views.last_viewed_at
        )
      ORDER BY ex.last_activity_at DESC
      LIMIT 1
    SQL
  end

  def exercises_sql
    <<-SQL
      SELECT
        ex.id,
        ex.key AS uuid,
        ex.language,
        ex.slug,
        ex.user_id,
        ex.last_activity,
        ex.last_activity_at,
        ex.iteration_count,
        u.username,
        u.avatar_url
      FROM user_exercises ex
      INNER JOIN users u
        ON ex.user_id=u.id
      INNER JOIN acls
        ON ex.language=acls.language
        AND ex.slug=acls.slug
      WHERE acls.user_id=#{user.id}
        AND ex.language='#{track_id}'
        AND ex.slug=#{slug_param}
        AND ex.archived='f'
        AND ex.slug != 'hello-world'
        AND ex.iteration_count > 0
      ORDER BY ex.last_activity_at DESC
      LIMIT #{per_page} OFFSET #{offset}
    SQL
  end

  def mark_as_read_update_sql
    <<-SQL
      UPDATE views
      SET last_viewed_at=NOW()
      FROM user_exercises ex
      INNER JOIN acls
        ON ex.language=acls.language
        AND ex.slug=acls.slug
      WHERE views.exercise_id=ex.id
        AND views.user_id=#{user.id}
        AND ex.language='#{track_id}'
        AND ex.slug=#{slug_param}
        AND acls.user_id=#{user.id}
    SQL
  end

  def mark_as_read_insert_sql
    <<-SQL
      INSERT INTO views (
        user_id, exercise_id, last_viewed_at, created_at, updated_at
      ) (
        SELECT #{user.id}, ex.id, NOW(), NOW(), NOW()
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE ex.language='#{track_id}'
          AND ex.slug=#{slug_param}
          AND acls.user_id=#{user.id}
          AND ex.id NOT IN (
            SELECT exercise_id
            FROM views
            WHERE user_id=#{user.id}
        )
      )
    SQL
  end

  def slug_param
    if slug.nil?
      'ex.slug'
    else
      "'#{slug}'"
    end
  end

  def offset
    (page-1)*per_page
  end
end

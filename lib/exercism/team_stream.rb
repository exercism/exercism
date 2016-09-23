require 'will_paginate/array'

# TeamStream is an activity stream for a given team.
# It does not restrict against the usual Access Control Lists.
# If you are on the team, then you are allowed to see the code.
# This can be narrowed down by track, track & problem, user, or user & track.
# rubocop:disable Metrics/ClassLength
class TeamStream
  attr_reader :team, :viewer_id, :page, :track_id, :user_id, :username, :slug
  attr_accessor :per_page

  def initialize(team, viewer_id, page=1, per_page=50)
    @team = team
    @viewer_id = viewer_id
    @page = page.to_i
    @per_page = per_page.to_i
  end

  def track_id=(track_id)
    @track_id = track_id.downcase if track_id
  end

  def slug=(slug)
    @slug = slug.downcase if slug
  end

  def user=(user)
    @user_id = user.id
    @username = user.username
    user
  end

  def user_ids
    @user_ids ||= TeamMembership.where(team_id: team.id, confirmed: true).pluck(:user_id).map(&:to_i)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def title
    problem = Problem.new(track_id, slug)

    case mode
    when :unfiltered
      team.name
    when :user
      if track_id.nil?
        username
      else
        "%s (%s)" % [username, problem.language]
      end
    when :track
      if slug.nil?
        problem.language
      else
        [problem.language, problem.name].join(" ")
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def menus
    @menus ||= [menu1, menu2, menu3]
  end

  def menu1
    @menu1 ||= TeamStream::TeamFilter.new(viewer_id, user_ids, team.slug)
  end

  def menu2
    @menu2 ||= if mode == :user
                 TeamStream::UserFilter.new(viewer_id, user_ids, team.slug, username)
               else
                 TeamStream::TrackFilter.new(viewer_id, user_ids, team.slug, track_id)
               end
  end

  # rubocop:disable Metrics/AbcSize
  def menu3
    @menu3 ||= case mode
               when :user
                 TeamStream::UserTrackFilter.new(viewer_id, [user_id], team.slug, username, track_id)
               when :track
                 TeamStream::ProblemFilter.new(viewer_id, user_ids, team.slug, track_id, slug)
               else
                 TeamStream::UserFilter.new(viewer_id, user_ids, team.slug, username)
               end
  end
  # rubocop:enable Metrics/AbcSize

  def exercises
    @exercises ||= query_exercises
  end

  def pagination
    (1..pagination_menu_item.total).to_a.paginate(page: page, per_page: per_page)
  end

  def pagination_menu_item
    menu3.items.find(&:active?) || menu2.items.find(&:active?) || menu1.items.find(&:active?)
  end

  # This becomes unbearably slow if we do a left join on views to get the unread value
  # up front.
  # If performance is still a problem, remove the join on user and do a separate lookup
  # for that as well.
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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
        row["help_requested"] == 't',
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
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
  end

  def comment_counts(ids)
    return [] if ids.empty?

    execute(comment_counts_sql(ids)).map { |row| [row["id"], row["total"]] }
  end

  def viewed(ids)
    return [] if ids.empty?

    execute(viewed_sql(ids)).map { |row| row["id"] }
  end

  # rubocop:disable Metrics/MethodLength
  def viewed_sql(ids)
    <<-SQL
      SELECT ex.id
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
        AND ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.id IN (#{ids.join(',')})
    SQL
  end
  # rubocop:enable Metrics/MethodLength

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

  # rubocop:disable Metrics/MethodLength
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
        ex.help_requested,
        u.username,
        u.avatar_url
      FROM user_exercises ex
      INNER JOIN users u
        ON ex.user_id=u.id
      WHERE ex.language=#{track_param}
        AND ex.slug=#{slug_param}
        AND ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
      ORDER BY ex.last_activity_at DESC
      LIMIT #{per_page} OFFSET #{offset}
    SQL
  end
  # rubocop:enable Metrics/MethodLength

  def track_param
    if track_id.nil?
      "ex.language"
    else
      "'#{track_id}'"
    end
  end

  def slug_param
    if slug.nil?
      'ex.slug'
    else
      "'#{slug}'"
    end
  end

  def user_ids_param
    case
    when user_ids.empty?
      "NULL"
    when user_id.nil?
      user_ids.join(",")
    else
      user_id
    end
  end

  def offset
    (page - 1) * per_page
  end

  def mode
    case
    when track_id.nil? && user_id.nil?
      :unfiltered
    when !user_id.nil?
      :user
    else
      :track
    end
  end
end

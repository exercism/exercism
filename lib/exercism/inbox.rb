require 'will_paginate/array'

class Inbox
  class Exercise < Struct.new(:uuid, :problem, :last_activity_at, :username, :avatar_url)

    def at
      @at ||= last_activity_at.to_datetime
    end

    def viewed!
      @viewed = true
    end

    def unread
      !@viewed
    end
  end

  attr_reader :user, :page, :track_id, :slug, :language
  attr_accessor :per_page
  def initialize(user, track_id, slug=nil, page=1)
    @user = user
    @track_id = track_id.downcase
    @slug = slug.downcase if !!slug
    @language = Language.of(track_id)
    @page = page.to_i
    @per_page = 50
  end

  def title
    if slug.nil?
      language
    else
      [language, Problem.new(track_id, slug).name].join(" ")
    end
  end

  def current_problem
  end

  def total_pages
    @total_pages ||= (current_track.total/per_page.to_f).ceil
  end

  def previous_page
    if page == 1
      1
    else
      page - 1
    end
  end

  def next_page
    if page == total_pages
      total_pages
    else
      page + 1
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
    (1..current_track.total).to_a.paginate(page: page, per_page: per_page)
  end

  private

  def current_track
    @current_track ||= tracks.find {|track| track.id == track_id} || UserTrack.new(track_id, 0, 0)
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
      ex = Exercise.new(row["uuid"], problem, row["last_activity_at"], row["username"], row["avatar_url"])
      exx << ex

      ids << row["id"]
      by_id[row["id"]] = ex
    end

    viewed(ids).each do |id|
      exx_by_id[id].viewed!
    end

    exx
  end

  def execute(sql)
    ActiveRecord::Base.connection.execute(sql).to_a
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
        AND ex.id IN ('#{ids.join("','")}')
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
        ex.last_activity_at,
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

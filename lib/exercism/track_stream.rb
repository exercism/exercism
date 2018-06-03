# TrackStream is an activity stream which has been filtered against the user's access list.
# Additionally, it can be narrowed down to a single exercise within a track.
class TrackStream
  include ActivityStream
  attr_reader :user, :page, :track_id, :slug, :language, :only_mine
  attr_accessor :per_page
  def initialize(user, track_id, slug=nil, page=1, only_mine=false)
    @user = user
    @track_id = track_id.to_s.downcase
    @slug = slug.downcase if slug
    @language = Language.of(track_id)
    @page = page.to_i
    @per_page = 50
    @only_mine = only_mine
  end

  def mark_as_read
    execute(mark_as_read_insert_sql)
    execute(mark_as_read_update_sql)
  end

  def title
    if slug.nil?
      language
    else
      [language, Problem.new(track_id, slug).name].join(" ")
    end
  end

  def menus
    @menus ||= [
      TrackStream::TrackFilter.new(user.id, track_id),
      TrackStream::ViewerFilter.new(user.id, track_id, only_mine),
      TrackStream::ProblemFilter.new(user.id, track_id, slug),
    ]
  end

  def pagination_menu_item
    active_menu_item || Stream::FilterItem.new(nil, nil, nil, nil, 0)
  end

  def active_menu_item
    if only_mine
      menus.second.items.first
    elsif by_problem?
      menus.last.items.find(&:active?)
    else
      menus.first.items.find(&:active?)
    end
  end

  def by_problem?
    slug.present?
  end

  def watermarks(problem_ids)
    return [] if problem_ids.empty?

    Watermark.where(user_id: user.id).where("track_id || ':' || slug IN (?)", problem_ids)
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
        AND ex.iteration_count > 0
        AND ex.id IN (#{ids.join(',')})
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
        ex.help_requested,
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
        AND ex.iteration_count > 0
        #{'AND ex.user_id =' + user.id.to_s if only_mine}
      ORDER BY ex.last_activity_at DESC
      LIMIT #{per_page} OFFSET #{offset}
    SQL
  end

  def mark_as_read_update_sql
    <<-SQL
      UPDATE watermarks
      SET at=NOW()
      FROM user_exercises ex
      INNER JOIN acls
        ON ex.language=acls.language
        AND ex.slug=acls.slug
      WHERE ex.language='#{track_id}'
        AND ex.slug=#{slug_param}
        AND acls.user_id=#{user.id}
        AND watermarks.track_id=ex.language
        AND watermarks.slug=ex.slug
        AND watermarks.user_id=#{user.id}
    SQL
  end

  def mark_as_read_insert_sql
    <<-SQL
      INSERT INTO watermarks (
        user_id, track_id, slug, at
      ) (
        SELECT DISTINCT #{user.id}, ex.language, ex.slug, NOW()
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE ex.language='#{track_id}'
          AND ex.slug=#{slug_param}
          AND acls.user_id=#{user.id}
          AND ex.language || ex.slug NOT IN (
            SELECT track_id || slug
            FROM watermarks
            WHERE user_id=#{user.id}
          )
      )
    SQL
  end
end

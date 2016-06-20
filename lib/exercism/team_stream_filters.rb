class TeamStream
  class Filter
    attr_reader :viewer_id, :user_ids, :team_slug, :current_id
    def initialize(viewer_id, user_ids, team_slug, current_id=nil)
      @viewer_id = viewer_id
      @user_ids = user_ids
      @team_slug = team_slug
      @current_id = current_id
    end

    def items
      @items ||= rows.map { |row| item(row["id"], row["total"]) }
                     .sort(&order)
                     .each do |item|
        item.unread = [item.total - views_by_id[item.id], 0].max
      end
    end

    private

    def order
      proc { 0 }
    end

    def views_by_id
      @views_by_id ||= execute(views_sql).each_with_object(Hash.new(0)) do |row, views|
        views[row["id"]] = row["total"].to_i
      end
    end

    def rows
      execute(sql)
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query).to_a
    end

    def user_ids_param
      if user_ids.empty?
        "NULL"
      else
        user_ids.join(",")
      end
    end
  end

  class SubFilter < Filter
    attr_reader :current_sub_id
    def initialize(viewer_id, user_ids, team_slug, current_id, current_sub_id)
      @viewer_id = viewer_id
      @user_ids = user_ids
      @team_slug = team_slug
      @current_id = current_id
      @current_sub_id = current_sub_id
    end
  end

  class TeamFilter < Filter
    private

    def sql
      <<-SQL
      SELECT 1 AS id, COUNT(id) AS total
      FROM user_exercises
      WHERE archived='f'
        AND iteration_count > 0
        AND user_id IN (#{user_ids_param})
      SQL
    end

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
      SELECT 'team_stream' AS id, COUNT(1) AS total
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
        AND views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(_, total)
      Stream::FilterItem.new('team_stream', 'All', url, true, total.to_i)
    end

    def url
      "/teams/%s/streams" % team_slug
    end
  end

  class TrackFilter < Filter
    private

    def order
      ->(a, b) { a.text <=> b.text }
    end

    def sql
      <<-SQL
      SELECT language AS id, COUNT(id) AS total
      FROM user_exercises
      WHERE archived='f'
        AND iteration_count > 0
        AND user_id IN (#{user_ids_param})
      GROUP BY language
      SQL
    end

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
      SELECT ex.language AS id, COUNT(views.id) AS total
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
        AND views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
      GROUP BY ex.language
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(track_id, total)
      Stream::FilterItem.new(track_id, Language.of(track_id), url(track_id), track_id == current_id, total.to_i)
    end

    def url(id)
      "/teams/%s/streams/tracks/%s" % [team_slug, id]
    end
  end

  class ProblemFilter < SubFilter
    private

    def order
      ->(a, b) { idx(a.id) <=> idx(b.id) }
    end

    def idx(id)
      Stream.ordered_slugs(current_id).index(id) || Stream.ordered_slugs(current_id).size
    end

    def sql
      <<-SQL
      SELECT slug AS id, COUNT(id) AS total
      FROM user_exercises
      WHERE archived='f'
        AND iteration_count > 0
        AND user_id IN (#{user_ids_param})
        AND language='#{current_id}'
      GROUP BY slug
      SQL
    end

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
      SELECT ex.slug AS id, COUNT(views.id) AS total
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
        AND ex.language='#{current_id}'
        AND views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
      GROUP BY ex.slug
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(slug, total)
      Stream::FilterItem.new(slug, namify(slug), url(slug), slug == current_sub_id, total.to_i)
    end

    def namify(slug)
      slug.split('-').map(&:capitalize).join(' ')
    end

    def url(id)
      "/teams/%s/streams/tracks/%s/exercises/%s" % [team_slug, current_id, id]
    end
  end

  class UserFilter < Filter
    private

    def order
      ->(a, b) { a.id.downcase <=> b.id.downcase }
    end

    def sql
      <<-SQL
      SELECT u.username AS id, COUNT(ex.id) AS total
      FROM users u
      INNER JOIN user_exercises ex
        ON u.id=ex.user_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
      GROUP BY u.username
      SQL
    end

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
      SELECT u.username AS id, COUNT(views.id) AS total
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      INNER JOIN users u
        ON u.id=ex.user_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
        AND views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
      GROUP BY u.username
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(username, total)
      Stream::FilterItem.new(username, username, url(username), username == current_id, total.to_i)
    end

    def url(id)
      "/teams/%s/streams/users/%s" % [team_slug, id]
    end
  end

  class UserTrackFilter < SubFilter
    private

    def order
      ->(a, b) { a.text <=> b.text }
    end

    def sql
      <<-SQL
        SELECT language AS id, COUNT(id) AS total
        FROM user_exercises
        WHERE archived='f'
          AND iteration_count > 0
          AND user_id IN (#{user_ids_param})
        GROUP BY language
      SQL
    end

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
      SELECT ex.language AS id, COUNT(views.id) AS total
      FROM views
      INNER JOIN user_exercises ex
        ON ex.id=views.exercise_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id IN (#{user_ids_param})
        AND views.user_id=#{viewer_id}
        AND views.last_viewed_at > ex.last_activity_at
      GROUP BY ex.language
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(track_id, total)
      Stream::FilterItem.new(track_id, Language.of(track_id), url(track_id), track_id == current_sub_id, total.to_i)
    end

    def url(id)
      "/teams/%s/streams/users/%s/tracks/%s" % [team_slug, current_id, id]
    end
  end
end

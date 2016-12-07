class TrackStream
  class Filter
    attr_reader :viewer_id, :track_id

    def items
      @items ||= execute(items_sql).map do |row|
        item(row["id"], row["total"])
      end.sort(&order).each do |item|
        item.unread = unread(item)
      end
    end

    private

    def unread(item)
      [item.total - read(item.id), 0].max
    end

    def read(id)
      views_by_id[id] + watermarked_by_id[id]
    end

    # By default, don't bother changing the order.
    def order
      proc { 0 }
    end

    def views_by_id
      @views_by_id ||= execute(views_sql).each_with_object(Hash.new(0)) do |row, views|
        views[row["id"]] = row["total"].to_i
      end
    end

    def watermarked_by_id
      @watermarked_by_id ||= execute(watermarks_sql).each_with_object(Hash.new(0)) do |row, watermarked|
        watermarked[row["id"]] = row["total"].to_i
      end
    end

    def execute(query)
      ActiveRecord::Base.connection.execute(query).to_a
    end
  end

  class TrackFilter < Filter
    def initialize(viewer_id, track_id)
      @viewer_id = viewer_id
      @track_id = track_id
    end

    private

    def order
      ->(a, b) { a.text <=> b.text }
    end

    # rubocop:disable Metrics/MethodLength
    def items_sql
      <<-SQL
        SELECT ex.language AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE acls.user_id=#{viewer_id}
          AND ex.archived='f'
          AND ex.iteration_count > 0
        GROUP BY ex.language
      SQL
    end

    def views_sql
      <<-SQL
        SELECT ex.language AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        INNER JOIN views
          ON ex.id=views.exercise_id
          AND acls.user_id=views.user_id
        WHERE acls.user_id=#{viewer_id}
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND views.last_viewed_at > ex.last_activity_at
          AND ex.language || ex.slug NOT IN (
            SELECT track_id || slug
            FROM watermarks
            WHERE user_id=#{viewer_id}
            AND at > ex.last_activity_at
          )
        GROUP BY ex.language
      SQL
    end

    def watermarks_sql
      <<-SQL
        SELECT ex.language AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        INNER JOIN watermarks mark
          ON ex.language=mark.track_id
          AND ex.slug=mark.slug
          AND acls.user_id=mark.user_id
        WHERE acls.user_id=#{viewer_id}
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND mark.at > ex.last_activity_at
        GROUP BY ex.language
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(id, total)
      Stream::FilterItem.new(id, Language.of(id), url(id), id == track_id, total.to_i)
    end

    def url(id)
      "/tracks/%s/exercises" % id
    end
  end

  class ProblemFilter < Filter
    attr_reader :slug
    def initialize(viewer_id, track_id, slug)
      @viewer_id = viewer_id
      @track_id = track_id
      @slug = slug
    end

    private

    def order
      ->(a, b) { idx(a.id) <=> idx(b.id) }
    end

    # Put deprecated stuff (and weirdo accidental submissions) at the very end.
    def idx(id)
      Stream.ordered_slugs(track_id).index(id) || Stream.ordered_slugs(track_id).size
    end

    # rubocop:disable Metrics/MethodLength
    def items_sql
      <<-SQL
        SELECT ex.slug AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE acls.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND ex.archived='f'
          AND ex.iteration_count > 0
        GROUP BY ex.slug
      SQL
    end

    def views_sql
      <<-SQL
        SELECT ex.slug AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        INNER JOIN views
          ON ex.id=views.exercise_id
          AND acls.user_id=views.user_id
        WHERE acls.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND views.last_viewed_at > ex.last_activity_at
          AND ex.language || ex.slug NOT IN (
            SELECT track_id || slug
            FROM watermarks
            WHERE user_id=#{viewer_id}
            AND at > ex.last_activity_at
          )
        GROUP BY ex.slug
      SQL
    end

    def watermarks_sql
      <<-SQL
        SELECT ex.slug AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        INNER JOIN watermarks mark
          ON ex.language=mark.track_id
          AND ex.slug=mark.slug
          AND acls.user_id=mark.user_id
        WHERE acls.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND mark.at > ex.last_activity_at
        GROUP BY ex.slug
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(id, total)
      Stream::FilterItem.new(id, namify(id), url(id), id == slug, total.to_i)
    end

    def namify(slug)
      slug.split('-').map(&:capitalize).join(' ')
    end

    def url(id)
      "/tracks/%s/exercises/%s" % [track_id, id]
    end
  end

  class ViewerFilter < Filter
    private

    attr_reader :track_id, :viewer_id, :only_mine
    def initialize(viewer_id, track_id, only_mine)
      @viewer_id = viewer_id
      @track_id = track_id
      @only_mine = only_mine
    end

    # rubocop:disable Metrics/MethodLength
    def items_sql
      <<-SQL
        SELECT u.username AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN users u
          ON u.id=ex.user_id
        WHERE ex.archived='f'
          AND ex.iteration_count > 0
          AND ex.user_id = #{viewer_id}
          AND ex.language='#{track_id}'
        GROUP BY u.username
      SQL
    end

    def views_sql
      <<-SQL
        SELECT u.username AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN users u
          ON u.id=ex.user_id
        INNER JOIN views
          ON views.user_id=u.id
          AND views.exercise_id=ex.id
        WHERE ex.archived='f'
          AND ex.iteration_count > 0
          AND ex.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND views.last_viewed_at > ex.last_activity_at
          AND ex.language || ex.slug NOT IN (
            SELECT track_id || slug
            FROM watermarks
            WHERE user_id=#{viewer_id}
            AND at > ex.last_activity_at
          )
        GROUP BY u.username
      SQL
    end

    def watermarks_sql
      <<-SQL
        SELECT u.username AS id, COUNT(ex.id) AS total
        FROM user_exercises ex
        INNER JOIN users u
          ON u.id=ex.user_id
        INNER JOIN watermarks mark
          ON ex.language=mark.track_id
          AND ex.slug=mark.slug
          AND ex.user_id=mark.user_id
        WHERE ex.archived='f'
          AND ex.iteration_count > 0
          AND ex.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND mark.at > ex.last_activity_at
        GROUP BY u.username
      SQL
    end
    # rubocop:enable Metrics/MethodLength

    def item(username, total)
      Stream::FilterItem.new(username, 'My Solutions', url, only_mine, total.to_i)
    end

    def url
      "/tracks/%s/my_solutions" % [track_id]
    end
  end
end

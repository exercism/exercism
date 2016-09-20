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
    # rubocop:enable Metrics/AbcSize

    private

    def unread(item)
      [item.total - views_by_id[item.id], 0].max
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

    def execute(query)
      ActiveRecord::Base.connection.execute(query).to_a
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
      FROM users u
      INNER JOIN user_exercises ex
        ON u.id=ex.user_id
      WHERE ex.archived='f'
        AND ex.iteration_count > 0
        AND ex.user_id = #{viewer_id}
        AND ex.language='#{track_id}'
      GROUP BY u.username
      SQL
    end

    def unread(_item)
      0
    end

    def item(username, total)
      Stream::FilterItem.new(username, 'My Solutions', url, only_mine, total.to_i)
    end

    # come up with the url
    def url
      "/tracks/%s/my_solutions" % [track_id]
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
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
        SELECT ex.language AS id, COUNT(views.id) AS total
        FROM views
        INNER JOIN user_exercises ex
          ON ex.id=views.exercise_id
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE acls.user_id=#{viewer_id}
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND views.user_id=#{viewer_id}
          AND views.last_viewed_at > ex.last_activity_at
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
    # rubocop:enable Metrics/MethodLength

    # rubocop:disable Metrics/MethodLength
    def views_sql
      <<-SQL
        SELECT ex.slug AS id, COUNT(views.id) AS total
        FROM views
        INNER JOIN user_exercises ex
          ON ex.id=views.exercise_id
        INNER JOIN acls
          ON ex.language=acls.language
          AND ex.slug=acls.slug
        WHERE acls.user_id=#{viewer_id}
          AND ex.language='#{track_id}'
          AND ex.archived='f'
          AND ex.iteration_count > 0
          AND views.user_id=#{viewer_id}
          AND views.last_viewed_at > ex.last_activity_at
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
end

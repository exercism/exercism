class TrackStream
  class Filter
    include ActivityStream::Filter
    attr_reader :viewer_id, :track_id
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
    def sql
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
    def sql
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
    def sql
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

  class TeamFilter < Filter
    attr_reader :viewer_id, :language, :slug, :team
    def initialize(viewer_id, language, slug, team)
      @viewer_id = viewer_id
      @language = language
      @slug = slug
      @team = team
    end

    def sql
      <<-SQL
        SELECT t.id AS id, COUNT(e.id) AS total
        FROM user_exercises e
        INNER JOIN users u
          ON  u.id=e.user_id
        INNER JOIN team_memberships m
          ON  m.user_id=u.id
          AND m.confirmed='t'
        INNER JOIN teams t
          ON  t.id=m.team_id
        INNER JOIN team_memberships um
          ON  um.team_id=t.id
          AND um.confirmed='t'
          AND um.user_id=#{viewer_id}
        WHERE e.slug='#{slug}'
          AND e.iteration_count > 0
          AND e.language='#{language}'
          AND e.archived='f'
        GROUP BY t.id
      SQL
    end

    def views_sql
      <<-SQL
        SELECT t.id AS id, COUNT(e.id) AS total
        FROM views v
        INNER JOIN user_exercises e
          ON  e.id=v.exercise_id
          AND e.slug='#{slug}'
          AND e.iteration_count > 0
          AND e.language='#{language}'
          AND e.archived='f'
        INNER JOIN users u
          ON  u.id=e.user_id
        INNER JOIN team_memberships m
          ON  m.user_id=u.id
          AND m.confirmed='t'
        INNER JOIN teams t
          ON  t.id=m.team_id
        INNER JOIN team_memberships um
          ON  um.team_id=t.id
          AND um.confirmed='t'
          AND um.user_id=#{viewer_id}
        WHERE v.user_id=#{viewer_id}
          AND v.last_viewed_at > e.last_activity_at
        GROUP BY t.id
      SQL
    end

    def item(id, total)
      t = Team.find(id)
      Stream::FilterItem.new(id, t.name, url(t), team && team.id == id, total.to_i)
    end

    def url(team)
      "/tracks/%s/exercises/%s/%s" % [language, slug, team.slug]
    end
  end
end

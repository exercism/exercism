module ExercismLib
  class Stats
    attr_reader :track_id, :slugs
    def initialize(track_id, slugs)
      @track_id = track_id
      @slugs = slugs
    end

    def to_h
      {
        labels: slugs,
        iterations: extract('iterations'),
        reviews: extract('reviews'),
      }
    end

    def to_json
      to_h.to_json
    end

    private

    def extract(key)
      data = Array.new(slugs.length, 0)
      rows.each do |row|
        data[slugs.index(row['slug'])] = row[key].to_i
      end
      data
    end

    def rows
      @rows ||= ActiveRecord::Base.connection.execute(sql).to_a
    end

    def sql
      <<-SQL
        SELECT s.slug, COUNT(s.id) AS iterations, COUNT(c.id) AS reviews
        FROM submissions s
        LEFT JOIN comments c
        ON s.id=c.submission_id
        WHERE s.created_at>'#{Date.today-30}'
        AND (c.user_id IS NULL OR s.user_id<>c.user_id)
        AND s.language='#{track_id}'
        GROUP BY s.slug
      SQL
    end

  end
end

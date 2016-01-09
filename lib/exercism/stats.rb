module ExercismLib
  class Stats
    attr_reader :track_id, :slugs
    def initialize(track_id, slugs)
      @track_id = track_id
      @slugs = slugs
    end

    def to_chart
      {
        labels: slugs,
        iterations: chartify('iterations'),
        reviews: chartify('reviews'),
      }.to_json
    end

    def apize
      data = {}

      slugs.each.with_index do |slug, i|
        data[slug] = {"iterations" => 0, "reviews" => 0, "index" => i}
      end

      rows.each do |row|
        data[row["slug"]]["iterations"] = row["iterations"].to_i
        data[row["slug"]]["reviews"] = row["reviews"].to_i
      end

      data
    end

    private

    def chartify(key)
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

require 'date'

module ExercismLib
  class Stats
    class Month
      def self.prev(range)
        d = range.first.prev_month
        new(d.year, d.month)
      end

      def self.historical(n)
        d = Date.today
        r = new(d.year, d.month)
        n.times.map { r = prev(r) }
      end

      attr_reader :year, :month
      def initialize(year, month)
        @year = year
        @month = month
      end

      def to_s
        first.strftime("%B %Y")
      end

      def first
        Date.new(year, month, 1)
      end

      def last
        first.next_month - 1
      end
    end

    class LastN
      attr_reader :today, :n
      def initialize(n)
        @n = n
        @today = Date.today
      end

      def to_s
        "Past #{n} days"
      end

      def first
        today - n
      end

      def last
        today + 1
      end
    end

    attr_reader :track_id, :slugs, :month
    def initialize(track_id, slugs, month=LastN.new(30))
      @track_id = track_id
      @slugs = slugs
      @month = month
    end

    def historical(n)
      Month.historical(n).map do |month|
        self.class.new(track_id, slugs, month)
      end
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
        data[slug] = { "iterations" => 0, "reviews" => 0, "index" => i }
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
        i = slugs.index(row['slug'])
        next if i.nil?
        data[i] = row[key].to_i
      end
      data
    end

    def rows
      @rows ||= ActiveRecord::Base.connection.execute(sql).to_a
    end

    # rubocop:disable Metrics/MethodLength
    def sql
      <<-SQL
        SELECT s.slug, COUNT(s.id) AS iterations, COUNT(c.id) AS reviews
        FROM submissions s
        LEFT JOIN comments c
          ON s.id=c.submission_id
        WHERE s.created_at>='#{month.first}'
          AND s.created_at<'#{month.last}'
          AND (c.user_id IS NULL OR s.user_id<>c.user_id)
          AND s.language='#{track_id}'
        GROUP BY s.slug
      SQL
    end
    # rubocop:enable Metrics/MethodLength
  end
end

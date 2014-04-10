module Stats
  class SubmissionsSQL
    attr_reader :id, :year, :month
    def initialize(id, year, month)
      @id = id
      @year = year
      @month = month
    end

    def execute
      User.connection.execute(sql).to_a
    end

    def sql
      <<-SQL
      SELECT
        count(id) AS count, language, created_at::date AS date
      FROM
        submissions
      WHERE
        user_id = #{id}
      AND created_at BETWEEN '#{start_time}' AND '#{end_time}'
      GROUP BY
        language, created_at::date
      SQL
    end

    def start_time
      Time.utc(year, month, 1)
    end

    def end_time
      Time.utc(year, month, end_date.day, 23, 59, 59)
    end

    def end_date
      Date.new(year, month, -1)
    end
  end
end

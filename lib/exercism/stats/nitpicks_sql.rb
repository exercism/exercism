module Stats
  class NitpicksSQL
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
          count(c.id) AS count, s.language, c.created_at::date date
        FROM
          comments c
        INNER JOIN submissions s ON c.submission_id=s.id
        WHERE
          s.user_id != #{id}
        AND
          c.user_id = #{id}
        AND c.created_at BETWEEN '#{start_time}' AND '#{end_time}'
        GROUP BY
          s.language, c.created_at::date
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

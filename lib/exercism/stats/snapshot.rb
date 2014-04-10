module Stats
  # Quick-and-dirty.
  # Not quite sure what stats we actually want.
  class Snapshot
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def most_recent_submission_at
      sql = "SELECT created_at FROM submissions WHERE user_id = #{user.id} ORDER BY created_at DESC LIMIT 1"
      result = execute(sql)
      time_of result["created_at"] if result
    end

    def most_recent_nitpick_at
      sql = "SELECT created_at FROM comments WHERE user_id = #{user.id} ORDER BY created_at DESC LIMIT 1"
      result = execute(sql)
      time_of result["created_at"] if result
    end

    def active_exercise_count
      sql = "SELECT COUNT(id) AS tally FROM user_exercises WHERE user_id = #{user.id} AND state='pending'"
      execute(sql)["tally"]
    end

    def hibernating_exercise_count
      sql = "SELECT COUNT(id) AS tally FROM user_exercises WHERE user_id = #{user.id} AND state='hibernating'"
      execute(sql)["tally"]
    end

    def completed_exercise_count
      sql = "SELECT COUNT(id) AS tally FROM user_exercises WHERE user_id = #{user.id} AND state='done'"
      execute(sql)["tally"]
    end

    def total_nitpick_count
      sql = "SELECT COUNT(c.id) AS tally FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE c.user_id = #{user.id} AND s.user_id != #{user.id}"
      execute(sql)["tally"]
    end

    def total_submission_count
      sql = "SELECT count(id) AS tally FROM submissions WHERE user_id=#{user.id}"
      execute(sql)["tally"]
    end

    def total_language_count
      user.submissions.pluck(:language).uniq.count
    end

    def recent_nitpick_count
      sql = "SELECT COUNT(c.id) AS tally FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE c.user_id = #{user.id} AND s.user_id != #{user.id} AND c.created_at > '#{7.days.ago}'"
      execute(sql)["tally"]
    end

    def recent_submission_count
      sql = "SELECT count(id) AS tally FROM submissions WHERE user_id=#{user.id} AND created_at > '#{7.days.ago}'"
      execute(sql)["tally"]
    end

    def recent_language_count
      user.submissions.where('created_at > ?', 7.days.ago).pluck(:language).uniq.count
    end

    private

    def connection
      @connection ||= User.connection
    end

    def execute(sql)
      connection.execute(sql).to_a.first
    end

    def time_of(timestamp)
      Time.strptime(timestamp.gsub(/\.\d+$/, '') + " UTC", "%Y-%m-%d %H:%M:%S %Z")
    end
  end
end

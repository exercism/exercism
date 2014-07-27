class LifecycleEvent < ActiveRecord::Base
  def self.track(key, user_id, now=Time.now.utc)
    return if user_id.nil?

    unless find_by(key: key, user_id: user_id)
      create(key: key, user_id: user_id, happened_at: now)
    end
  rescue => e
    Bugsnag.notify(e)
  end

  def self.commented(id)
    sql = "SELECT COUNT(DISTINCT s.user_id) AS conversation_count FROM comments c INNER JOIN submissions s ON c.submission_id=s.id WHERE s.user_id != #{id}"
    if connection.execute(sql).to_a.first['conversation_count'].to_i > 3
      track('onboarded', id)
      sql = "UPDATE users SET onboarded_at=NOW() WHERE id=#{id}"
      connection.execute(sql)
    end
  end
end

class LifecycleEvent < ActiveRecord::Base
  def self.track(key, user_id, now=Time.now.utc)
    return if user_id.nil?

    unless find_by(key: key, user_id: user_id)
      create(key: key, user_id: user_id, happened_at: now)
    end
  rescue => e
    Bugsnag.notify(e)
  end
end

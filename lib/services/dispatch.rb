class Dispatch
  def self.notifications_for_user(user)
    Notification.recent_for_user(user)
  end
end

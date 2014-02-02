class NotificationCenter
  attr_reader :notifications

  def initialize(user)
    @notifications = user.notifications.read
  end

  def gc
    notifications.destroy_all
  end

  def delete(id)
    notification = notifications.find_by(id: id)
    notification.destroy if notification
  end
end

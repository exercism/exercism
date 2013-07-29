#requiring here doesn't feel right
require_relative '../helpers/fuzzy_time_helper'

class NotificationsPresenter
  include Sinatra::FuzzyTimeHelper

  def initialize(notifications)
    @notifications = transform(notifications)
  end
  
  def to_json
    @notifications.to_json
  end

  def transform(notifications)
    notifications.map { |notification|
      {
        id: notification.id,
        regarding: notification.regarding,
        read: notification.read,
        link: notification.link,
        from: notification.from,
        date: notification.at.to_time.to_i,
        humanReadableDate: ago(notification.at),
      }
    }
  end
end

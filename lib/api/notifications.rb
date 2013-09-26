class ExercismAPI < Sinatra::Base
  get '/notifications' do
    require_recipient
    notifications = recipient.notifications.recent
    pg :notifications, locals: {notifications: notifications}
  end

  # I think this should be
  # POST /notifications/:id/read
  put '/notifications/:id' do |id|
    require_recipient
    notification = recipient.notifications.find(id)
    notification.read!
    pg :notification, locals: {notification: notification}
  end
end


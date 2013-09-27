class ExercismAPI < Sinatra::Base
  get '/notifications' do
    require_user
    notifications = current_user.notifications.recent
    pg :notifications, locals: {notifications: notifications}
  end

  # I think this should be
  # POST /notifications/:id/read
  put '/notifications/:id' do |id|
    require_user
    notification = current_user.notifications.find(id)
    notification.read!
    pg :notification, locals: {notification: notification}
  end
end


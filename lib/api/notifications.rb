class ExercismAPI < Sinatra::Base
  get '/notifications' do
    require_user
    notifications = current_user.notifications.recent.without_alerts
    alerts = current_user.alerts.map {|alert| Api::Notifications::Alert.new(alert) }
    pg :notifications, locals: {notifications: alerts + notifications}
  end

  # I think this should be
  # POST /notifications/:id/read
  put '/notifications/:id' do |id|
    require_user

    if id =~ /alert/
      notification = current_user.alerts.find(id.split('alert-').last)
    else
      notification = current_user.notifications.find(id)
    end

    notification.read!
    pg :notification, locals: {notification: notification}
  end
end


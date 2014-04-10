module ExercismAPI
  module Routes
    class Notifications < Core
      # Notification endpoints are only used in the prototype.
      # Delete when redesign launches.
      get '/notifications' do
        require_user
        notifications = current_user.notifications.on_submissions.recent
        alerts = current_user.alerts.map {|alert| ExercismAPI::Presenters::Alert.new(alert) }
        pg :notifications, locals: {notifications: alerts + notifications}
      end

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
  end
end

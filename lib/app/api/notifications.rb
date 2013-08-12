class ExercismApp < Sinatra::Base
  helpers do
    def require_recipient
      unless recipient
        halt 401, {error: "Please provide API key or valid session"}.to_json
      end
    end

    def recipient
      return @recipient if @recipient

      if params[:key]
        @recipient = User.find_by(key: params[:key])
      elsif session[:github_id]
        @recipient = current_user
      end
    end
  end

  get '/api/v1/notifications' do
    require_recipient
    notifications = Notification.recent_for_user(recipient)
    pg :notifications, locals: {notifications: notifications}
  end

  # I think this should be
  # POST /api/v1/notifications/:id/read
  put '/api/v1/notifications/:id' do |id|
    require_recipient
    notification = recipient.notifications.find(id)
    notification.read!
    pg :notification, locals: {notification: notification}
  end
end


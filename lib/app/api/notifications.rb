class ExercismApp < Sinatra::Base
  helpers do
    def require_recipient
      unless recipient
        halt 401, {error: "Please provide API key or valid session"}.to_json
      end
    end

    def recipient
      @recipient ||= begin
        if params[:key]
          User.find_by(key: params[:key])
        elsif session[:github_id]
          current_user
        end
      end
    end
  end

  get '/api/v1/notifications' do
    require_recipient
    notifications = recipient.notifications.recent
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


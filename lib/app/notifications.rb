class ExercismApp < Sinatra::Base
  get '/notifications' do
    please_login

    notifications = current_user.notifications.about_nitpicks.by_recency
    erb :"notifications/index", locals: {notifications: notifications}
  end

  delete '/notifications/read' do
    unless current_user.guest?
      current_user.notifications.read.destroy_all
    end

    redirect '/notifications'
  end
end

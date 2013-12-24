class ExercismApp < Sinatra::Base
  get '/notifications' do
    please_login

    erb :"notifications/index", locals: {notifications: current_user.notifications.by_recency}
  end

  delete '/notifications/read' do
    unless current_user.guest?
      current_user.notifications.read.destroy_all
    end

    redirect '/notifications'
  end
end

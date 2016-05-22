module ExercismWeb
  module Routes
    class Notifications < Core
      get '/notifications' do
        please_login

        inbox = ExercismWeb::Presenters::Inbox.new(current_user)
        erb :"notifications/index", locals: { inbox: inbox }
      end

      post '/notifications/read' do
        please_login

        current_user.notifications.update_all(read: true)
        redirect '/notifications'
      end
    end
  end
end

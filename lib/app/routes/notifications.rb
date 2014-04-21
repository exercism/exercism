require 'app/presenters/inbox'

module ExercismWeb
  module Routes
    class Notifications < Core
      get '/notifications' do
        please_login

        inbox = ExercismWeb::Presenters::Inbox.new(current_user)
        erb :"notifications/index", locals: {inbox: inbox}
      end

      delete '/notifications/alert-:id' do |id|
        please_login

        current_user.alerts.where(id: id).destroy_all
        redirect '/notifications'
      end
    end
  end
end

module ExercismWeb
  module Routes
    class Tracks < Core
      get '/tracks/:id/exercises' do |id|
        please_login
        id = id.downcase

        page = params[:page] || 1
        inbox = Inbox.new(current_user, id, page)

        erb :"inbox", locals: {inbox: inbox}
      end
    end
  end
end

module ExercismWeb
  module Routes
    class Tracks < Core
      get '/tracks/:id/exercises/?:slug?' do |id, slug|
        please_login
        id, slug = id.downcase, slug.downcase

        page = params[:page] || 1
        inbox = Inbox.new(current_user, id, slug, page)

        erb :"inbox", locals: {inbox: inbox}
      end
    end
  end
end

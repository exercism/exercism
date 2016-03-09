module ExercismWeb
  module Routes
    class Tracks < Core
      get '/tracks/:id/exercises/?:slug?' do |id, slug|
        please_login

        page = params[:page] || 1
        stream = TrackStream.new(current_user, id, slug, page)

        session[:inbox] = id
        session[:inbox_slug] = slug

        erb :"track_stream/index", locals: {stream: stream}
      end

      post '/tracks/:id/views/?:slug?' do |id, slug|
        if current_user.guest?
          # silently ignore the request
          redirect '/'
        end

        TrackStream.new(current_user, id, slug).mark_as_read

        redirect ["", "tracks", id, "exercises", slug].compact.join('/')
      end
    end
  end
end

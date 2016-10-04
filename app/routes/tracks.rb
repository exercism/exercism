module ExercismWeb
  module Routes
    class Tracks < Core
      get '/tracks/:id/my_solutions' do |id|
        please_login
        page = params[:page] || 1
        stream = TrackStream.new(current_user, id, nil, page, true)
        session[:inbox] = id
        erb :"track_stream/index", locals: { stream: stream }
      end

      get '/tracks/:id/exercises/?:slug?' do |id, slug|
        please_login
        page = params[:page] || 1
        stream = TrackStream.new(current_user, id, slug, page)
        session[:inbox] = id
        session[:inbox_slug] = slug

        erb :"track_stream/index", locals: { stream: stream }
      end

      post '/tracks/:id/views/?:slug?' do |id, slug|
        if current_user.guest?
          # silently ignore the request
          redirect '/'
        end

        TrackStream.new(current_user, id, slug).mark_as_read

        redirect ["", "tracks", id, "exercises", slug].compact.join('/')
      end

      get '/tracks/:id/icon' do |id|
        icon = Trackler.tracks[id].icon
        if icon.exists?
          send_file icon.path, type: icon.type
        else
          send_file File.absolute_path("../../../public/img/e_red.png", __FILE__), type: :png
        end
      end
    end
  end
end

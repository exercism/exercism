module ExercismWeb
  module Routes
    class Inbox < Core
      get '/inbox' do
        please_login

        session[:inbox] ||= current_user.track_ids.first
        redirect ['', 'tracks', session[:inbox], 'exercises', session[:inbox_slug]].compact.join('/')
      end
    end
  end
end

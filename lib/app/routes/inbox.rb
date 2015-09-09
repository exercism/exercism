module ExercismWeb
  module Routes
    class Inbox < Core
      get '/inbox' do
        please_login

        session[:inbox] ||= current_user.track_ids.first
        redirect ['', 'tracks', session[:inbox], 'exercises'].join('/')
      end
    end
  end
end

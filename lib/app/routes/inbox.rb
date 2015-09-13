module ExercismWeb
  module Routes
    class Inbox < Core
      get '/inbox' do
        please_login

        session[:inbox] ||= ACL.select('DISTINCT language').where(user_id: current_user.id).order(:language).map(&:language).first
        redirect ['', 'tracks', session[:inbox], 'exercises', session[:inbox_slug]].compact.join('/')
      end
    end
  end
end

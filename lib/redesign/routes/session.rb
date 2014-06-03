module ExercismIO
  module Routes
    class Session < Core
      register ExercismWeb::Routes::GithubCallback

      get '/login' do
        redirect login_url
      end

      get '/logout' do
        logout
        redirect root_path
      end
    end
  end
end

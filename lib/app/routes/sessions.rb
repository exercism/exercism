module ExercismWeb
  module Routes
    class Sessions < Core
      register ExercismWeb::Routes::GithubCallback

      get '/please-login' do
        erb :"auth/please_login", locals: {return_path: params[:return_path]}
      end

      get '/login' do
        redirect Github.login_url(github_client_id)
      end

      get '/logout' do
        logout
        redirect root_path
      end
    end
  end
end

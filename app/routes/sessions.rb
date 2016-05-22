module ExercismWeb
  module Routes
    class Sessions < Core
      register ExercismWeb::Routes::GithubCallback

      get '/please-login' do
        erb :"auth/please_login", locals: { return_path: params[:return_path] }
      end

      get '/login' do
        q = { client_id: github_client_id }
        if params.key?("return_path")
          q[:redirect_uri] = [request.base_url, "github", "callback", params[:return_path]].join("/")
        end
        redirect Github.login_url(q)
      end

      get '/logout' do
        logout
        redirect root_path
      end
    end
  end
end

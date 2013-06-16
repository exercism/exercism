class ExercismApp < Sinatra::Base

  get '/logout' do
    logout
    redirect '/'
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      session[:github_id] = params[:id]
      redirect '/'
    end
  end

  get '/login' do
    redirect "https://github.com/login/oauth/authorize?client_id=#{ENV.fetch('EXERCISM_GITHUB_CLIENT_ID')}"
  end

  # Callback from github. This will include a temp code from Github that
  # we use to authenticate other requests. This code indicates whether
  # the user has said okay or not.
  get '/github/callback' do
    user = Authentication.perform(params[:code])
    login(user)
    redirect "/"
  end

end

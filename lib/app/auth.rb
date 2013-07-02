class ExercismApp < Sinatra::Base

  get '/logout' do
    logout
    redirect '/'
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      session[:github_id] = params[:id]

      if !current_user.admin? && current_user.submissions.count == 0
        redirect "/account"
      else
        redirect "/"
      end
    end
  end

  get '/login' do
    redirect "https://github.com/login/oauth/authorize?client_id=#{ENV.fetch('EXERCISM_GITHUB_CLIENT_ID')}"
  end

  # Callback from github. This will include a temp code from Github that
  # we use to authenticate other requests.
  # If we get a code, the user has said okay.
  get '/github/callback' do
    unless params[:code]
      halt 400, "Must provide parameter 'code'"
    end
    begin
      user = Authentication.perform(params[:code])
      login(user)
    rescue => e
      flash[:error] = "We're having trouble with logins right now. Please come back later"
      redirect '/'
    end

    if current_user.guest?
      flash[:error] = "We're having trouble with logins right now. Please come back later"
      redirect '/'
    elsif !current_user.admin? && current_user.submissions.count == 0
      redirect "/account"
    else
      redirect "/"
    end
  end

end

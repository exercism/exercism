class ExercismApp < Sinatra::Base

  get '/logout' do
    logout
    redirect '/'
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      if User.count == 0
        flash[:error] = "You'll want to run the seed script: `ruby scripts/seed.rb``"
        redirect '/'
      end

      session[:github_id] = params[:id]
      redirect "/"
    end
  end

  get '/please-login' do
    erb :please_login, locals: {return_path: params[:return_path]}
  end

  get '/login' do
    redirect Github.login_url
  end

  # Callback from github. This will include a temp code from Github that
  # we use to authenticate other requests.
  # If we get a code, the user has said okay.
  get '/github/callback/?*' do
    unless params[:code]
      halt 400, "Must provide parameter 'code'"
    end

    begin
      user = Authentication.perform(params[:code])
      login(user)
    rescue => e
      flash[:error] = "We're having trouble with logins right now. Please come back later"
    end

    if current_user.guest?
      flash[:error] = "We're having trouble with logins right now. Please come back later"
    end

    # params[:splat] might be an empty array
    # which suits us just fine.
    redirect "/#{params[:splat].first}"
  end

end

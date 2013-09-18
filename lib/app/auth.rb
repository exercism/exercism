class ExercismApp < Sinatra::Base
  helpers do
    def please_login(notice = nil)
      if current_user.guest?
        flash[:notice] = notice if notice
        redirect "/please-login?return_path=#{request.path_info}"
      end
    end

    def login_url(return_path = nil)
      url = Github.login_url
      if return_path
        url << "&redirect_uri=#{site_root}/github/callback#{return_path}"
      end
      url
    end

    def login(user)
      session[:github_id] = user.github_id
    end

    def logout
      session[:github_id] = nil
      @current_user = nil
    end
  end

  get '/logout' do
    logout
    redirect '/'
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      if User.count == 0
        flash[:error] = "You'll want to run the seed script: `rake db:seed`"
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


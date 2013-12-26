class ExercismApp < Sinatra::Base
  get '/logout' do
    logout
    redirect root_path
  end

  if ENV['RACK_ENV'] == 'development'
    get '/backdoor' do
      if User.count == 0
        flash[:error] = "You'll want to run the seed script: `rake db:seed`"
        redirect root_path
      end

      login(User.find_by_github_id(params[:id]))
      redirect root_path
    end
  end

  get '/please-login' do
    erb :"auth/please_login", locals: {return_path: params[:return_path]}
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
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    if current_user.guest?
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    # params[:splat] might be an empty array
    # which suits us just fine.
    redirect [root_path, params[:splat].first].join('/')
  end

end


class ExercismApp < Sinatra::Base
  get '/logout' do
    logout
    redirect root_path
  end

  if settings.development?
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
    redirect Github.login_url(github_client_id)
  end

  get '/github/callback/?*' do
    unless params[:code]
      halt 400, "Must provide parameter 'code'"
    end

    begin
      user = Authentication.perform(params[:code], github_client_id, github_client_secret)
      login(user)
    rescue => e
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    if current_user.guest?
      flash[:error] = "We're having trouble with logins right now. Please come back later."
    end

    path = params[:splat].first
    path = nil if path == ""
    redirect [root_path, path].compact.join('/')
  end
end

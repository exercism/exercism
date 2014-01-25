class ExercismV1p0 < Sinatra::Base
  get '/logout' do
    logout
    redirect root_path
  end

  get '/please-login' do
    status 403
    haml :"auth/please_login", locals: {return_path: params[:return_path]}
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
    if path.nil? || path.empty?
      redirect link_to('/ohai')
    else
      redirect [root_path, path].compact.join('/')
    end
  end
end

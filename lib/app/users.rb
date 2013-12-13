class ExercismApp < Sinatra::Base

  get '/account' do
    please_login

    title('account')
    erb :account, locals: { profile: Profile.new(current_user) }
  end

  get '/:username' do |username|
    please_login
    user = User.find_by_username(username)

    if user
      title(user.username)
      erb :user, locals: { profile: Profile.new(user, current_user) }
    else
      status 404
      erb :not_found
    end
  end

  get '/:username/nitstats' do |username|
    please_login
    user = User.find_by_username(username)
    if user
      stats = Nitstats.new(user)
      title("#{user.username} - Nit Stats")
      erb :nitstats, locals: {user: user, stats: stats }
    else
      status 404
      erb :not_found
    end
  end

end

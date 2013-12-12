class ExercismApp < Sinatra::Base

  get '/account' do
    please_login

    title('account')
    erb :account
  end

  get '/:username' do |username|
    please_login
    user = User.find_by_username(username)

    if user
      title(user.username)
      erb :user, locals: {user: user, current: user.current_exercises, completed: user.completed_exercises}
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

class ExercismApp < Sinatra::Base

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

end

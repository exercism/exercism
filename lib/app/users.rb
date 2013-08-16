class ExercismApp < Sinatra::Base

  get '/:username' do |username|
    user = User.where(username: username).first
    halt 404 unless user
    title(user.username)
    erb :user, locals: {user: user, current: user.current_exercises, completed: user.completed_exercises}
  end

end

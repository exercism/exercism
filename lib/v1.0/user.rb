class ExercismV1p0 < Sinatra::Base
  get '/:username/:key' do |username, key|
    please_login
    user = User.find_by_username(username)
    exercise = user.exercises.find_by_key(key)
    haml :"user/exercise", locals: {exercise: App::User::Exercise.new(exercise)}
  end

  get '/account' do
    please_login

    haml :"user/account", locals: {account: App::User::Account.new(current_user)}
  end
end

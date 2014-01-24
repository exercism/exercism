class ExercismV1p0 < Sinatra::Base
  helpers do
    def nav
      @nav ||= App::User::Navigation.new(current_user)
    end

    def account
      @account ||= App::User::Account.new(current_user)
    end
  end

  get '/:username/:key' do |username, key|
    please_login
    user = User.find_by_username(username)
    exercise = user.exercises.find_by_key(key)
    haml :"user/exercise", locals: {exercise: App::User::Exercise.new(exercise)}
  end
end

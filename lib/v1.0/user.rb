class ExercismV1p0 < Sinatra::Base
  helpers do
    def current_user
      @current_user ||= User.find_by_key(params[:current_user])
    end

    def nav
      @nav ||= App::User::Navigation.new(current_user)
    end

    def account
      @account ||= App::User::Account.new(current_user)
    end
  end

  get '/:username/:key' do |username, key|
    unless params[:current_user]
      halt 400, "Tell me who you are. Add ?current_user=YOUR_API_KEY to the url"
    end
    user = User.find_by_username(username)
    exercise = user.exercises.find_by_key(key)
    haml :"user/exercise", locals: {exercise: App::User::Exercise.new(exercise)}, layout: false
  end
end

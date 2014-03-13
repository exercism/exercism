require 'v1.0/site/languages'

class ExercismApp < Sinatra::Base

  get '/' do
    if settings.development?
      @assumable_users = User.all
    end
    if current_user.guest?
      current = App::Site::Languages.new(Exercism::Config.current)
      upcoming = App::Site::Languages.new(Exercism::Config.upcoming)
      erb :"site/index", locals: {current: current, upcoming: upcoming}
    else
      erb :"site/dashboard", locals: {submission: Work.new(current_user).random}
    end
  end

  get '/privacy' do
    erb :"site/privacy"
  end

  get '/about' do
    erb :"site/about"
  end

end

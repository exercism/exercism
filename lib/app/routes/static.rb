module ExercismWeb
  module Routes
    class Static < Core
      get '/' do
        if current_user.guest?
          current = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
          upcoming = ExercismIO::Presenters::Languages.new(Exercism::Config.upcoming)
          haml :"site/index", locals: {current: current, upcoming: upcoming}
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

      get '/getting-started' do
        languages = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
        haml :"site/getting-started", locals: {languages: languages}
      end
    end
  end
end

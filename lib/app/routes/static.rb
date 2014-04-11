module ExercismWeb
  module Routes
    class Static < Core
      get '/' do
        if current_user.guest?
          current = ExercismIO::Presenters::Languages.new(Exercism::Config.current)
          upcoming = ExercismIO::Presenters::Languages.new(Exercism::Config.upcoming)
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
  end
end

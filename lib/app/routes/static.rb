module ExercismWeb
  module Routes
    class Static < Core
      get '/' do
        if current_user.guest?
          upcoming = ExercismWeb::Presenters::Languages.new(Exercism::Config.upcoming)
          haml :"site/index", locals: {current: current_languages, upcoming: upcoming}
        else
          erb :"site/dashboard", locals: {submission: Work.new(current_user).random}
        end
      end

      get '/privacy' do
        erb :"site/privacy"
      end

      get '/about' do
        erb :"site/about", locals: {languages: current_languages}
      end

      get '/getting-started' do
        haml :"site/getting-started", locals: {languages: current_languages}
      end

      private

      def current_languages
        ExercismWeb::Presenters::Languages.new(Exercism::Config.current)
      end
    end
  end
end

module ExercismWeb
  module Routes
    class Static < Core
      get '/privacy' do
        erb :"site/privacy"
      end

      get '/about' do
        erb :"site/about", locals: {languages: current_languages}
      end

      get '/getting-started' do
        haml :"site/getting-started", locals: {languages: current_languages}
      end

      get '/bork' do
        raise RuntimeError.new("Hi Bugsnag, you're awesome!")
      end

      private

      def current_languages
        ExercismWeb::Presenters::Languages.new(Exercism::Config.current)
      end
    end
  end
end

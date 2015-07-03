module ExercismWeb
  module Routes
    class Static < Core
      before do
        cache_control :public
      end

      get '/rikki' do
        erb :"site/rikki"
      end

      get '/donate' do
        erb :"site/donate"
      end

      get '/privacy' do
        erb :"site/privacy"
      end

      get '/about' do
        erb :"site/about", locals: {active_languages: active_languages, upcoming_languages: upcoming_languages, planned_languages: planned_languages}
      end

      get '/getting-started' do
        erb :"site/getting-started", locals: {active_languages: active_languages}
      end

      get '/bork' do
        raise RuntimeError.new("Hi Bugsnag, you're awesome!")
      end

      get '/no-such-page' do
        status 404
        erb :"errors/not_found"
      end
    end
  end
end

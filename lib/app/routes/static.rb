module ExercismWeb
  module Routes
    class Static < Core
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

      get "/installing-cli" do
        erb :"site/installing-cli", locals: { active_languages: active_languages }
      end
      
      get "/java-exercises" do
        erb :"site/java-exercises"
      end
      
      get "/ruby-exercises" do
        erb :"site/ruby-exercises"
      end
      
      get "/javascript-exercises" do
        erb :"site/javascript-exercises"
      end
  
      get "/create-assignment" do
        erb :"site/create-assignment", locals: { active_languages: active_languages }
      end

      get "/submit-assignment" do
        erb :"site/submit-assignment", locals: { active_languages: active_languages }
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

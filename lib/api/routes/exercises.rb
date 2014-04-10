module ExercismAPI
  module Routes
    class Exercises < Core
      get '/exercises' do
        require_user
        content_type 'application/json', :charset => 'utf-8'
        Homework.new(current_user).all.to_json
      end

      get '/exercises/:language' do |language|
        Xapi.get("exercises", language)
      end

      get '/exercises/:language/:slug' do |language, slug|
        Xapi.get("exercises", language, slug)
      end
    end
  end
end

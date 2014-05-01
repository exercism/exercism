module ExercismAPI
  module Routes
    class Exercises < Core
      get '/exercises' do
        require_key
        if current_user.guest?
          halt 400, {error: "Sorry—we can't figure out who you are. Double-check your API key in your exercism.io account page."}.to_json
        end

        exercises = begin
          Homework.new(current_user).all.to_json
        rescue Xapi::ApiError => e
          {error: e.message}
        rescue Exception
          {error: "Something went wrong, and it's not clear what it was. Please post an issue on GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"}
        end
      end

      get '/exercises/:language' do |language|
        halt *Xapi.get("exercises", language)
      end

      get '/exercises/:language/:slug' do |language, slug|
        halt *Xapi.get("exercises", language, slug)
      end
    end
  end
end

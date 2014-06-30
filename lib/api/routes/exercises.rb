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
        rescue Exception => e
          Bugsnag.notify(e)
          halt 500, {error: "Something went wrong, and it's not clear what it was. Please post an issue on GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"}.to_json
        end
      end

      get '/exercises/:language' do |language|
        halt *Xapi.get("exercises", language, :key => current_user.key)
      end

      get '/exercises/:language/:slug' do |language, slug|
        halt *Xapi.get("assignments", language, slug)
      end
    end
  end
end

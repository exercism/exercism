module ExercismAPI
  module Routes
    class Exercises < Core
      get '/exercises' do
        require_key

        if current_user.guest?
          halt 400, {error: "Sorry—we can't figure out who you are. Double-check your API key in your exercism.io account page."}.to_json
        end

        exercises = begin
          result = Homework.new(current_user).all.to_json
          LifecycleEvent.track('fetched', current_user.id)
          result
        rescue Exception => e
          Bugsnag.notify(e)
          halt 500, {error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"}.to_json
        end
      end

      get '/exercises/:language' do |language|
        status, data = Xapi.get("exercises", language, :key => current_user.key)
        LifecycleEvent.track('fetched', current_user.id)
        halt status, data
      end

      get '/exercises/:language/:slug' do |language, slug|
        status, data = Xapi.get("assignments", language, slug)
        LifecycleEvent.track('fetched', current_user.id)
        halt status, data
      end
    end
  end
end

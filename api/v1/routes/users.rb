module ExercismAPI
  module Routes
    class Users < Core
      # Looks up usernames by partial input.
      # Used from the web frontend when writing comments.
      get '/user/find/?' do
        content_type :json
        UserLookup.new(params).lookup.to_json
      end

      get '/users/:username/statistics' do |username|
        user = User.find_by(username: username)
        if user.nil?
          halt 404, {error: "unknown user #{username}"}.to_json
        end

        begin
          content_type :json
          UserStatistics.of(user).to_json
        rescue Exception => e
          Bugsnag.notify(e, nil, request)
          halt 500, {error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"}.to_json
        end
      end
    end
  end
end

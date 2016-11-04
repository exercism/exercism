module ExercismAPI
  module Routes
    class Users < Core
      # Looks up usernames by partial input.
      # Used from the web frontend when writing comments.
      get '/user/find' do
        content_type :json
        UserLookup.new(params).lookup.to_json
      end

      get '/users/:username/statistics' do |username|
        halt 404, {error: "We've been cleaning up. This endpoint got deleted."}.to_json
      end
    end
  end
end

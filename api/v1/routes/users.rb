module ExercismAPI
  module Routes
    class Users < Core
      # Looks up usernames by partial input.
      # Used from the web frontend when writing comments.
      get '/user/find' do
        content_type :json
        UserLookup.new(params).lookup.to_json
      end
    end
  end
end

module ExercismAPI
  module Routes
    class Users < Core
      get '/user/find' do
        content_type :json
        UserLookup.new(params).lookup.to_json
      end
    end
  end
end

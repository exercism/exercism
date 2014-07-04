module ExercismAPI
  module Routes
    class Users < Core
      post '/user/find' do
        content_type :json
        query = params[:query]
        return query_user.to_json
      end
    end
  end
end

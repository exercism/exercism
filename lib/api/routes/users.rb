module ExercismAPI
  module Routes
    class Users < Core
      post '/user/find' do
        content_type :json
        if params[:query]
          User.where('username LIKE ?', '%' + params[:query] + '%').pluck(:username).to_json
        else
          "[]"
        end
      end
    end
  end
end

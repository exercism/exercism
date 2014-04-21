require 'app/presenters/look'

module ExercismWeb
  module Routes
    class Looks < Core
      get '/looks' do
        please_login

        looks = ExercismWeb::Presenters::Look.wrap(Look.recent_for(current_user))
        erb :"looks/index", locals: {looks: looks}
      end
    end
  end
end

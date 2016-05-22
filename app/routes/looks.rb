module ExercismWeb
  module Routes
    class Looks < Core
      get '/looks' do
        please_login

        pagination = {
          page: params[:page],
          per_page: params[:per_page] || 50,
        }
        exercises = UserExercise.recently_viewed_by(current_user).paginate(pagination)
        erb :"looks/index", locals: { exercises: exercises }
      end
    end
  end
end

module ExercismWeb
  module Routes
    class Main < Core
      get '/' do
        erb :"site/index"
      end

      get '/dashboard' do
        if current_user.onboarded?
          status = Onboarding.status(current_user.onboarding_steps)
          dashboard = ExercismWeb::Presenters::Dashboard.new(current_user)
          recently_viewed = UserExercise.recently_viewed_by(current_user)

          locals = {
            user: current_user,
            status: status,
            dashboard: dashboard,
            recently_viewed_exercises: recently_viewed.limit(6),
            recently_viewed_more: recently_viewed.count > 6,
          }
          erb :"dashboard", locals: locals
        else
          redirect "/onboarding"
        end
      end
    end
  end
end

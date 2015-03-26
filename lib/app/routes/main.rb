module ExercismWeb
  module Routes
    class Main < Core
      get '/' do
        if current_user.guest?
          erb :"site/index", layout: :hootcode
        elsif current_user.onboarded?
          status = Onboarding.status(current_user.onboarding_steps)
          dashboard = ExercismWeb::Presenters::Dashboard.new(current_user)
          erb :"dashboard", locals: {status: status, dashboard: dashboard}
        else
          redirect "/onboarding"
        end
      end

    end
  end
end

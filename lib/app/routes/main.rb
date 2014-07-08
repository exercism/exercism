module ExercismWeb
  module Routes
    class Main < Core
      get '/' do
        if current_user.guest?
          upcoming = ExercismWeb::Presenters::Languages.new(Exercism::Config.upcoming)
          current = ExercismWeb::Presenters::Languages.new(Exercism::Config.current)
          haml :"site/index", locals: {current: current, upcoming: upcoming}
        else
          status = Onboarding.status(current_user.onboarding_steps)
          dashboard = ExercismWeb::Presenters::Dashboard.new(current_user)
          erb :"dashboard", locals: {status: status, dashboard: dashboard}
        end
      end

    end
  end
end

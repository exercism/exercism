module ExercismWeb
  module Routes
    class Main < Core
      get '/' do
        if current_user.guest?
          erb :"site/index"
        elsif current_user.onboarded?
          status = Onboarding.status(current_user.onboarding_steps)
          dashboard = ExercismWeb::Presenters::Dashboard.new(current_user)
          looks = ExercismWeb::Presenters::Look.wrap(Look.recent_for(current_user))
          stats = Nitstats.new(current_user)
        # erb :"looks/index", locals: {looks: looks}
          erb :"dashboard", locals: {stats: stats, user: current_user, status: status, dashboard: dashboard, looks: looks}
        else
          redirect "/onboarding"
        end
      end

    end
  end
end

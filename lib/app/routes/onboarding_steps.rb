module ExercismWeb
  module Routes
    class OnboardingSteps < Core

      get '/onboarding/joined' do
        dashboard_layout_for("joined")
      end

      get '/onboarding/fetched' do
        dashboard_layout_for("fetched")
      end

      get '/onboarding/submitted' do
        dashboard_layout_for("submitted")
      end

      get '/onboarding/received_feedback' do
        dashboard_layout_for("received_feedback")
      end

      get '/onboarding/completed' do
        dashboard_layout_for("completed")
      end

      get '/onboarding/commented' do
        dashboard_layout_for("commented")
      end

      get '/onboarding/onboarded' do
        dashboard_layout_for("onboarded")
      end

      private
      def current_users_dashboard
        ExercismWeb::Presenters::Dashboard.new(current_user)
      end

      def dashboard_layout_for(status)
        erb :"dashboard", locals: {status: status, dashboard: current_users_dashboard}
      end
    end
  end
end

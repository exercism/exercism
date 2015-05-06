module ExercismWeb
  module Routes
    class OnboardingSteps < Core
      get '/onboarding/?' do
        if current_user.onboarded?
          redirect '/'
        else
          redirect "/onboarding/#{Onboarding.current_step(current_user.onboarding_steps)}"
        end
      end

      get '/onboarding/install-cli' do
        erb :"onboarding/get_configuration_key", locals: {dashboard: dashboard}
      end

      get '/onboarding/submit-code' do
        erb :"onboarding/submit_code", locals: {dashboard: dashboard}
      end

      get '/onboarding/have-a-conversation' do
        erb :"onboarding/have_a_conversation", locals: {dashboard: dashboard}
      end

      get '/onboarding/pay-it-forward' do
        erb :"onboarding/pay_it_forward", locals: {dashboard: dashboard}
      end

      private
      def dashboard
        ExercismWeb::Presenters::Dashboard.new(current_user)
      end
    end
  end
end

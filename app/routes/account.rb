module ExercismWeb
  module Routes
    class Account < Core
      get '/account' do
        please_login

        title('account')
        erb :"account/show", locals: { profile: Presenters::Profile.new(current_user) }
      end

      put '/account/email' do
        if current_user.guest?
          halt 403, "You must be logged in to edit your email settings"
        end

        current_user.email = params[:email]
        current_user.save
        flash[:success] = 'Updated email address.'
        redirect "/account"
      end

      get '/account/key' do
        please_login
        erb :"account/key"
      end

      # Reset exercism API key
      put '/account/key/reset' do
        please_login

        # This could fail, but I don't know
        # what the user should see in that case.
        # Do we even have a way of showing a message?
        current_user.reset_key
        redirect "/account"
      end
    end
  end
end

module ExercismWeb
  module Routes
    class User < Core
      # User's profile page.
      # This is going to get a serious overhaul.
      get '/:username' do |username|
        please_login
        user = ::User.find_by_username(username)

        if user
          title(user.username)
          erb :"user/show", locals: { profile: Profile.new(user, current_user) }
        else
          status 404
          erb :"errors/not_found"
        end
      end

      # Reset exercism API key
      put '/me/uuid/reset' do
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

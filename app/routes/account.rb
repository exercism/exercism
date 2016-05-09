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

      put '/account/share-key/set' do
        please_login
        current_user.set_share_key
        redirect "/account"
      end

      put '/account/share-key/unset' do
        please_login
        current_user.unset_share_key
        redirect "/account"
      end

      post '/account/track-mentor/invite' do
        please_login

        begin
          user_to_invite = ::User.find_by_username(params[:user_to_invite])
          track = params[:track]

          user_to_invite.present? or fail "couldn't find user for #{user_to_invite.username}"
          track.present? or fail "track cannot be blank"
          !(user_to_invite == current_user) or fail "you cannot invite yourself"
          current_user.track_mentor.include?(track) or fail "you must be mentor for #{track} first"
          !user_to_invite.track_mentor.include?(track) or fail "#{user_to_invite.username} is already a mentor for #{track}"

          user_to_invite.invite_to_track_mentor(track)

          flash[:notice] = "Successfully invited #{user_to_invite.username} to mentor #{track.capitalize}"
          redirect "/account"
        rescue StandardError => se
          flash[:notice] = "Error while inviting: #{se}"
          redirect "/account"
        end
      end
    end
  end
end

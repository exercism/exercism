module ExercismWeb
  module Routes
    class Account < Core
      get "/account" do
        please_login

        title("account")
        erb :"account/show", locals: { profile: Profile.new(current_user) }
      end

      put "/account" do
        if current_user.guest?
          halt 403, "You must be logged in to edit your account settings"
        end
        if current_user.update(params[:account])
          flash[:success] = "Updated account settings."
        else
          flash[:error] = current_user.errors.full_messages.join(", ")
        end
        redirect "/account"
      end

      put "/update_assignment" do
        if current_user.guest?
          halt 403, "You must be logged in to edit your account settings"
        else
          if settings.production?
            `cd ~/home/ubuntu/exercism/x-api && git submodule init && git submodule update --remote --merge`
            flash[:success] = "Assignment Updated Successfully"
          end
        end
          redirect "/account"
      end
    end
  end
end

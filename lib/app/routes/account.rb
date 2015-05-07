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

      get "/fetch_git_submodules" do
        if current_user.guest?
          halt 403, "You must be logged in to edit your account settings"
        else
          if settings.production?
            status, message = Xapi.get("problems", "fetch", "git", "submodules")
            if status == 200
              flash[:success] = message
            else
              flash[:error] = "Error in fetching assignments. Please try later."
            end
          end
        end
        redirect "/account"
      end
    end
  end
end

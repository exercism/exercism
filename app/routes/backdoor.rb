module ExercismWeb
  module Routes
    class Backdoor < Core
      get '/backdoor' do
        if ::User.count == 0
          flash[:error] = "You'll want to run the seed script: `rake db:seed`"
          redirect root_path
        end

        session.clear
        login(::User.find_by_github_id(params[:id]))
        redirect root_path
      end
    end
  end
end

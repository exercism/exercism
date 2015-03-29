module ExercismWeb
  module Routes
    module GithubCallback
      def self.registered(app)
        app.get '/github/callback/?*' do
          unless params[:code]
            halt 400, "Must provide parameter 'code'"
          end

          begin
            user = Authentication.perform(params[:code], github_client_id, github_client_secret)
            login(user)
          rescue StandardError => e
            Bugsnag.notify(e)
            flash[:error] = "We're having trouble with logins right now. Please come back later."
          end

          if current_user.guest?
            flash[:error] = "We're having trouble with logins right now. Please come back later."
          end

          path = params[:splat].first
          if path.nil? || path.empty?
            redirect root_path
          else
            redirect File.join([root_path, path].compact)
          end
        end
      end
    end
  end
end

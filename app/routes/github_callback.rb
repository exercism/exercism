module ExercismWeb
  module Routes
    module GithubCallback
      # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      def self.registered(app)
        app.get '/github/callback/?*' do
          halt 400, "Must provide parameter 'code'" unless params[:code]

          begin
            user = Authentication.perform(params[:code], github_client_id, github_client_secret, session[:target_profile])
            login(user)
          rescue StandardError => e
            Bugsnag.notify(e, nil, request)
            flash[:error] = "We're having trouble with logins right now. Please come back later."
          end

          if current_user.guest?
            flash[:error] = "We're having trouble with logins right now. Please come back later."
          end

          path = params[:splat].first
          if path.nil? || path.empty?
            redirect '/dashboard'
          else
            redirect File.join([root_path, path].compact)
          end
        end
      end
      # rubocop:enable Metrics/MethodLength, Metrics/AbcSize
    end
  end
end

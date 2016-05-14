module ExercismWeb
  module Helpers
    module Session
      def login(user)
        session[:github_id] = user.github_id
        @current_user = user
      end

      def logout
        session.clear
        @current_user = nil
      end

      def current_user
        @current_user ||= logged_in_user || Guest.new
      end

      def login_url(return_path=nil)
        url = Github.login_url(client_id: github_client_id)
        url << redirect_uri(return_path) if return_path
        url
      end

      def please_login(notice=nil)
        if current_user.guest?
          flash[:notice] = notice if notice
          redirect link_to("/please-login?return_path=#{request.path_info}")
        end
      end

      private

      def redirect_uri(return_path)
        "&redirect_uri=http://#{host.chomp('/')}/github/callback#{return_path}"
      end

      def logged_in_user
        User.find_by(github_id: session[:github_id]) if session[:github_id]
      end
    end
  end
end

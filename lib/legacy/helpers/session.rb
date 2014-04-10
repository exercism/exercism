module ExercismLegacy
  module Helpers
    module Session
      def require_user
        if current_user.guest?
          halt 401, {error: "You must be logged in to access this feature"}.to_json
        end
      end

      def current_user
        @current_user ||= find_user || Guest.new
      end

      def find_user
        if session[:github_id]
          User.where(github_id: session[:github_id]).first
        end
      end
    end
  end
end

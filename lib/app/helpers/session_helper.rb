module Sinatra
  module SessionHelper
    def current_user
      @current_user ||= logged_in_user || Guest.new
    end

    def logged_in_user
      if session[:github_id]
        User.where(github_id: session[:github_id]).first
      end
    end
  end
end


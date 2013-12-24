module Sinatra
  module SessionHelper
    def please_login(notice = nil)
      if current_user.guest?
        flash[:notice] = notice if notice
        redirect "/please-login?return_path=#{request.path_info}"
      end
    end

    def login_url(return_path = nil)
      url = Github.login_url
      if return_path
        url << "&redirect_uri=http://#{site_root}/github/callback#{return_path}"
      end
      url
    end

    def login(user)
      session[:github_id] = user.github_id
      @current_user = user
    end

    def logout
      session[:github_id] = nil
      @current_user = nil
    end

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


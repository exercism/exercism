require 'exercism'
require 'sinatra/petroglyph'

require 'app/api'
require 'app/api/notifications_api'
require 'app/auth'
require 'app/client'
require 'app/curriculum'
require 'app/submissions'
require 'app/exercises'
require 'app/dashboard'
require 'app/trails'
require 'app/about'
require 'app/presenters/notifications_presenter'
require 'app/nitpick'
require 'app/helpers/site_title_helper'
require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/gravatar_helper'
require 'app/helpers/github_link_helper'

require 'services'

class ExercismApp < Sinatra::Base

  set :environment, ENV.fetch('RACK_ENV') { 'development' }.to_sym
  set :root, 'lib/app'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash

  helpers Sinatra::SiteTitleHelper
  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::GravatarHelper
  helpers Sinatra::GithubLinkHelper

  helpers do

    def site_root
      if ENV['RACK_ENV'].to_sym == :production
        'http://exercism.io'
      else
        'http://localhost:4567'
      end
    end

    def please_login(return_path = nil)
      if current_user.guest?
        redirect "/please-login?return_path=#{return_path}"
      end
    end

    def login_url(return_path = nil)
      url = Github.login_url
      if return_path
        url << "&redirect_uri=#{site_root}/github/callback#{return_path}"
      end
      url
    end

    def login(user)
      session[:github_id] = user.github_id
    end

    def logout
      session[:github_id] = nil
      @current_user = nil
    end

    def current_user
      return @current_user if @current_user

      if session[:github_id]
        @current_user = User.find_by(github_id: session[:github_id])
      else
        @current_user = Guest.new
      end
    end

    def md(text, language = nil)
      if language
        Markdown.render("```#{language}\n#{text}\n```")
      else
        Markdown.render(text)
      end
    end

    def language_icon(language,html={})
      %{<div class="language circle #{html[:class]} #{language}-icon">&nbsp;</div>}
    end

    def dashboard_nav_li(location, html={})
      path = location.downcase == "featured" ? "/" : "/dashboard/#{location.downcase}"
      active = path == request.path_info ? "active" : ""
      %{<li class="#{active} #{html[:class]}"><a href="#{path}">#{location}</a></li>}
    end
  end

end

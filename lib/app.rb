require 'exercism'
require 'sinatra/petroglyph'

require 'app/about'
require 'app/nitpick'
require 'app/api'
require 'app/api/notifications_api'
require 'app/auth'
require 'app/client'
require 'app/curriculum'
require 'app/submissions'
require 'app/exercises'
require 'app/dashboard'
require 'app/trails'
require 'app/users'
require 'app/presenters/notifications_presenter'
require 'app/not_found' # always include last

require 'app/helpers/site_title_helper'
require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/gravatar_helper'
require 'app/helpers/github_link_helper'
require 'app/helpers/profile_helper'

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
  helpers Sinatra::ProfileHelper

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

    def path_for(language=nil)
      if language
        "/dashboard/#{language.downcase}"
      else
        "/"
      end
    end

    def active_nav(path)
      if path == request.path_info
        "active"
      else
        ""
      end
    end

    def active_top_nav(path=nil)
      if path == "/"
        active_nav(path)
      elsif request.path_info.match(/#{path}/)
        "active"
      else
        ""
      end
    end

    def nav_text(slug=nil)
      (slug || "featured").split("-").map(&:capitalize).join(" ")
    end

    def dashboard_nav_li(language=nil, html={})
      path = path_for(language)
      %{<li class="#{active_top_nav(path)} #{html[:class]}"><a href="#{path}">#{nav_text(language)}</a></li>}
    end

    def dashboard_assignment_nav(language, exercise=nil, html={})
      path = path_for(language)
      path += "/#{exercise}/" if exercise
      %{<li class="#{active_nav(path)} #{html[:class]}"><a href="#{path}">#{nav_text(exercise)}</a></li>}
    end

    def exercises_available_for(language)
      Exercism.current_curriculum.in(language).exercises.select {|exercise|
        current_user.nitpicker_on?(exercise)
      }
    end

    def unstarted_trails
      @unstarted_trails ||= Exercism.current_curriculum.unstarted_trails(current_user.current_languages)
    end

    def show_pending_submissions?(language)
      (!language && current_user.nitpicker?) || (language && current_user.nitpicks_trail?(language))
    end

    def n_people_like_it(n)
      case n
        when 0 then ""
        when 1 then "1 person thinks this looks great"
      else
        "#{n} people think this looks great"
      end
    end
  end

end

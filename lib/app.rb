require 'exercism'
require 'sinatra/petroglyph'
require 'will_paginate'
require 'will_paginate/active_record'

require 'app/presenters/workload'

require 'app/auth'
require 'app/client'
require 'app/curriculum'
require 'app/help'
require 'app/nitpick'
require 'app/nitpick_history'
require 'app/setup'
require 'app/submissions'
require 'app/teams'
require 'app/users'

# Must be included at this point in order
require 'app/exercises'
require 'app/not_found'

require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/github_link_helper'
require 'app/helpers/gravatar_helper'
require 'app/helpers/profile_helper'
require 'app/helpers/site_title_helper'
require 'app/helpers/submissions_helper'
require 'app/helpers/markdown_helper'

require 'services'

class ExercismApp < Sinatra::Base

  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, 'lib/app'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash

  helpers WillPaginate::Sinatra::Helpers
  helpers Sinatra::SubmissionsHelper
  helpers Sinatra::SiteTitleHelper
  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::GravatarHelper
  helpers Sinatra::GithubLinkHelper
  helpers Sinatra::ProfileHelper
  helpers Sinatra::MarkdownHelper

  helpers do

    def site_root
      if ENV['RACK_ENV'].to_sym == :production
        'http://exercism.io'
      else
        'http://localhost:4567'
      end
    end

    def current_user
      @current_user ||= logged_in_user || Guest.new
    end

    def logged_in_user
      if session[:github_id]
        User.where(github_id: session[:github_id]).first
      end
    end

    def language_icon(language,html={})
      %{<div class="language circle #{html[:class]} #{language}-icon">&nbsp;</div>}
    end

    def path_for(language=nil, section='nitpick')
      if language
        "/#{section}/#{language.downcase}"
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

    def nav_text(slug)
      if slug == 'opinions'
        slug = 'wants second opinion'
      end
      slug.split("-").map(&:capitalize).join(" ")
    end

    def dashboard_assignment_nav(language, slug=nil, counts=nil)
      return if !['no-nits', 'opinions', 'looks-great'].include?(slug) && (!counts || counts.zero?)

      path = path_for(language)
      path += "/#{slug}" if slug
      tally = counts ? " (#{counts})" : ""
      %{<li class="#{active_nav(path)}"><a href="#{path}">#{nav_text(slug)}#{tally}</a></li>}
    end

    def show_pending_submissions?(language)
      (!language && current_user.nitpicker?) || (language && current_user.nitpicks_trail?(language))
    end

    def nitpicker_languages
      @nitpicker_languages ||= Exercism.languages.select { |lang|
        current_user.nitpicks_trail?(lang.to_s)
      }
    end
  end

end

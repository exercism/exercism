require 'exercism'
require 'sinatra/petroglyph'

require 'app/api'
require 'app/auth'
require 'app/client'
require 'app/curriculum'
require 'app/submissions'
require 'app/exercises'
require 'app/trails'
require 'app/about'
require 'app/nitpick'
require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/gravatar_helper'

require 'services'

class ExercismApp < Sinatra::Base

  set :environment, ENV.fetch('RACK_ENV') { 'development' }.to_sym
  set :root, 'lib/app'

  enable :sessions
  use Rack::Flash

  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::GravatarHelper

  helpers do

    def site_root
      if ENV['RACK_ENV'].to_sym == :production
        'http://exercism.io'
      else
        'http://localhost:4567'
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

  end

end

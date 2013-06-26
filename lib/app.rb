require 'exercism'
require 'sinatra/petroglyph'

require 'app/api'
require 'app/auth'
require 'app/client'
require 'app/submissions'
require 'app/exercises'
require 'app/trails'
require 'app/helpers/fuzzy_time_helper'
require 'app/helpers/gravatar_helper'

class ExercismApp < Sinatra::Base

  set :environment, ENV.fetch('RACK_ENV') { 'development' }.to_sym
  set :root, 'lib/app'

  enable :sessions
  use Rack::Flash

  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::GravatarHelper

  helpers do

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

  end

end

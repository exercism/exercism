require 'airbrake'
require 'exercism'
require 'sinatra/petroglyph'

require 'app/helpers/fuzzy_time_helper'
require 'api/helpers/gem_helper'

require 'api/assignments'
require 'api/notifications'
require 'api/stashes'

class ExercismAPI < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, 'lib/api'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash

  configure :production do
    Airbrake.configure do |config|
      config.api_key = ENV['AIRBRAKE_API_KEY']
    end

    use Airbrake::Rack
    enable :raise_errors
  end

  helpers Sinatra::FuzzyTimeHelper
  helpers Sinatra::GemHelper

  helpers do
    def require_user
      if current_user.guest?
        halt 401, {error: "You must be logged in to access this feature. Please double-check your API key."}.to_json
      end
    end

    def current_user
      @current_user ||= find_user || Guest.new
    end

    def find_user
      if request.cookies['_exercism_login']
        User.where(github_id: request.cookies['_exercism_login']).first
      elsif params[:key]
        User.where(key: params[:key]).first
      end
    end
  end
end


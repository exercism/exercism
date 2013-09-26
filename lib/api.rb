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
    # Temporarily, until I can get this sorted out.
    def current_user
      @current_user ||= begin
        if request.cookies['_exercism_login']
          User.find_by(github_id: request.cookies['_exercism_login'])
        else
          Guest.new
        end
      end
    end

    def require_recipient
      unless recipient
        halt 401, {error: "Please provide API key or valid session"}.to_json
      end
    end

    def recipient
      @recipient ||= begin
        if params[:key]
          User.find_by(key: params[:key])
        elsif request.cookies['_exercism_login']
          current_user
        end
      end
    end
  end
end


require 'exercism'
require 'sinatra/petroglyph'

require 'redesign/helpers/fuzzy_time'

require 'api/notifications/alert'

require 'api/assignments'
require 'api/exercises'
require 'api/iterations'
require 'api/notifications'
require 'api/stats'

class ExercismAPI < Sinatra::Base
  set :environment, ENV.fetch('RACK_ENV') { :development }.to_sym
  set :root, 'lib/api'
  set :method_override, true

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
  use Rack::Flash

  helpers ExercismIO::Helpers::FuzzyTime

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
      if session[:github_id]
        User.where(github_id: session[:github_id]).first
      elsif params[:key]
        User.where(key: params[:key]).first
      end
    end
  end
end


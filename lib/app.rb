require 'exercism'

require 'app/api'
require 'app/auth'
require 'app/client'

class ExercismApp < Sinatra::Base

  set :environment, ENV.fetch('RACK_ENV') { 'development' }.to_sym
  set :root, 'lib/app'

  enable :sessions
  use Rack::Flash

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

  end

end

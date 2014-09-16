
module ExercismAPI
  module Routes
    class Looks < Core
      configure do
        enable :sessions
        set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
      end

      get '/looks' do
        unless session[:github_id]
          halt 200, "[]"
        end
        user = User.find_by(github_id: session[:github_id])
        pg :looks, locals: {user: user, looks: Look.for(user)}
      end
    end
  end
end

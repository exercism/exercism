module ExercismAPI
  module Routes
    class Looks < Core
      configure do
        enable :sessions
        set :session_secret, ENV.fetch('SESSION_SECRET') { "Need to know only." }
      end

      get '/looks' do
        unless session['github_id']
          halt 200, {looks: []}.to_json
        end

        user = User.find_by(github_id: session['github_id'])
        if user.nil?
          halt 401, {looks: []}.to_json
        end

        pg :looks, locals: {looks: Presenters::Looks.for(user)}
      end
    end
  end
end

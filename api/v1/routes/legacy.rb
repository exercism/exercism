module ExercismAPI
  module Routes
    class Legacy < Core
      get '/user/assignments/restore' do
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/exercises/:track_id' do |_|
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/exercises/:track_id/:slug' do |_, _|
        halt 500, ERR_PLEASE_UPGRADE
      end

      get '/iterations/:key/restore' do |_|
        halt 500, ERR_PLEASE_UPGRADE
      end

      delete '/user/assignments' do
        message = "Unsubmit functionality has been disabled for security reasons.\n" \
          "You can delete submissions from the web interface."
        halt 404, { error: message }.to_json
      end
    end
  end
end

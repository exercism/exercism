module ExercismAPI
  module Routes
    class Legacy < Core
      get '/user/assignments/restore' do
        halt 500, ErrPleaseUpgrade
      end

      get '/exercises/:track_id' do |_|
        halt 500, ErrPleaseUpgrade
      end

      get '/exercises/:track_id/:slug' do |_, _|
        halt 500, ErrPleaseUpgrade
      end

      get '/iterations/:key/restore' do |key|
        halt 500, ErrPleaseUpgrade
      end

      delete '/user/assignments' do
        message = "Unsubmit functionality has been disabled for security reasons.\n" \
          "You can delete submissions from the web interface."
        halt 404, {error: message}.to_json
      end
    end
  end
end

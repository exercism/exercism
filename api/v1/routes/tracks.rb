module ExercismAPI
  module Routes
    class Tracks < Core
      # Status on a track for a user.
      # Called by the CLI.
      get '/tracks/:track_id/status' do |track_id|
        require_key

        track = Trackler.tracks[track_id]
        unless track.exists?
          message = "Track #{track_id} not found."
          halt 404, { error: message }.to_json
        end

        begin
          Homework.new(current_user).status(track_id).to_json
          # rubocop:disable Lint/RescueException
        rescue Exception => e
          Bugsnag.notify(e, nil, request)
          halt 500, { error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues" }.to_json
        end
      end

      get '/tracks/:id/images/*' do |id, path|
        image = Trackler.tracks[id].img(path)
        if image.exists?
          send_file image.path, type: image.type
        else
          halt 404
        end
      end
    end
  end
end

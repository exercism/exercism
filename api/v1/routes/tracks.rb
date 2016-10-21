module ExercismAPI
  module Routes
    class Tracks < Core
      # Status on a track for a user.
      # Called by the CLI.
      get '/tracks/:language/status' do |language|
        require_key

        track = Trackler.tracks[language]
        unless track.exists?
          message = "Track #{language} not found."
          halt 404, { error: message }.to_json
        end

        begin
          Homework.new(current_user).status(language).to_json
          # rubocop:disable Lint/RescueException
        rescue Exception => e
          Bugsnag.notify(e, nil, request)
          halt 500, { error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues" }.to_json
        end
      end
    end
  end
end

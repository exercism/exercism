module ExercismAPI
  module Routes
    class Tracks < Core
      # Status on a track for a user.
      # Called by the CLI.
      get '/tracks/:id/status' do |id|
        require_key

        if !Xapi.exists?(id)
          message = "Track #{id} not found."
          halt 404, { error: message }.to_json
        end

        begin
          Homework.new(User.find_by(key: params[:key])).status(id).to_json
          # rubocop:disable Lint/RescueException
        rescue Exception => e
          Bugsnag.notify(e, nil, request)
          halt 500, {error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues"}.to_json
        end
      end
    end
  end
end

# coding: utf-8
# rubocop:disable Lint/RescueException
# Allow all exceptions to be reported to Bugsnag

module ExercismAPI
  module Routes
    class Exercises < Core
      # This is the list of the user's solutions, and their current state.
      # Called from the CLI.
      get '/exercises' do
        halt 200, {}.to_json if current_user.guest?

        begin
          Homework.new(current_user).all.to_json
        rescue Exception => e
          Bugsnag.notify(e, nil, request)
          halt 500, { error: "Something went wrong, and it's not clear what it was. The error has been sent to our tracker. If you want to get involved, post an issue to GitHub so we can figure it out! https://github.com/exercism/exercism.io/issues" }.to_json
        end
      end
    end
  end
end

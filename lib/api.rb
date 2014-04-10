require 'exercism'
require 'sinatra/petroglyph'

module ExercismAPI
  ROOT = 'api'
end

require 'exercism/stats/nit_streak'
require 'exercism/stats/submission_streak'
require 'exercism/stats/snapshot'
require 'exercism/homework'
require 'exercism/xapi'

require 'api/presenters'
require 'api/routes'

module ExercismAPI
  class App < Sinatra::Base
    configure do
      # When redesign goes live, we can stop using sessions.
      # The notification endpoints need to share
      # the same session store as the main app.
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' }
    end

    use Routes::Demo
    use Routes::Exercises
    use Routes::Iterations
    use Routes::Stats
    use Routes::Notifications
    use Routes::Legacy
  end
end

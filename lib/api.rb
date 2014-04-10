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
      use Rack::Session::Cookie,
        :key => 'rack.session',
        :path => '/api/v1',
        :expire_after => 2592000,
        :secret => ENV.fetch('SESSION_SECRET') { 'Need to know only.' } + ExercismAPI::ROOT
    end

    use Routes::Demo
    use Routes::Exercises
    use Routes::Iterations
    use Routes::Stats
    use Routes::Notifications
    use Routes::Legacy
  end
end

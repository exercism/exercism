require 'exercism'
require 'sinatra/petroglyph'

module ExercismAPI
  ROOT = 'api'
end

require 'api/stats/nit_streak'
require 'api/stats/submission_streak'
require 'api/stats/snapshot'
require 'api/notifications/alert'
require 'api/exercises/homework'
require 'api/assignments/xapi'

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

    use Routes::Legacy
  end
end

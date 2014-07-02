require './config/bugsnag'
require 'exercism'
require 'sinatra/petroglyph'

module ExercismAPI
  ROOT = Exercism.relative_to_root('lib', 'api')
end

require 'exercism/stats/nit_streak'
require 'exercism/stats/submission_streak'
require 'exercism/stats/snapshot'
require 'exercism/homework'
require 'exercism/xapi'

require 'api/routes'

module ExercismAPI
  class App < Sinatra::Base
    use Routes::Demo
    use Routes::Exercises
    use Routes::Iterations
    use Routes::Stats
    use Routes::Legacy
  end
end

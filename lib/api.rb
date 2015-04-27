require './config/bugsnag'
require 'exercism'
require 'sinatra/petroglyph'

module ExercismAPI
  ROOT = Exercism.relative_to_root('lib', 'api')
end

require 'exercism/stats/snapshot'
require 'exercism/homework'
require 'exercism/xapi'

require 'api/routes'
require 'api/presenters'

module ExercismAPI
  class App < Sinatra::Base
    use Routes::Exercises
    use Routes::Iterations
    use Routes::Submissions
    use Routes::Problems
    use Routes::Comments
    use Routes::Looks
    use Routes::Stats
    use Routes::Users
    use Routes::Legacy
  end
end

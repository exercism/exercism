require './config/bugsnag'
require 'exercism'
require 'sinatra/petroglyph'

module ExercismAPI
  ROOT = Exercism.relative_to_root('api', 'v1')
end

require 'exercism/homework'

require_relative 'v1/routes'

module ExercismAPI
  class App < Sinatra::Base
    use Routes::Exercises
    use Routes::Iterations
    use Routes::Submissions
    use Routes::Comments
    use Routes::Users
    use Routes::Legacy
    use Routes::Tracks
    use Routes::Stats
  end
end

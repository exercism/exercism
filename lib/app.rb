require 'exercism'

require 'app/client'
require 'app/api'

class ExercismApp < Sinatra::Base
  set :root, 'lib/app'


end

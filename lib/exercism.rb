require 'faraday'
require 'exercism/locale'
require 'exercism/exercise'
require 'exercism/trail'
require 'exercism/assignment'
require 'exercism/curriculum'
require 'exercism/submission'
require 'exercism/nit'
require 'exercism/comment'
require 'exercism/locksmith'
require 'exercism/user'
require 'exercism/guest'
require 'exercism/null_submission'
require 'exercism/completed_exercise'
require 'exercism/markdown'
require 'exercism/input_sanitation'
require 'exercism/authentication'
require 'exercism/github'
require 'exercism/notification'
require 'exercism/use_cases'

Mongoid.load!("./config/mongoid.yml")

class Exercism
  # See lib/exercism/curriculum.rb for default curriculum setup
end

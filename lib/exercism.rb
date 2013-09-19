require 'faraday'
require 'exercism/locale'
require 'exercism/code'
require 'exercism/exercise'
require 'exercism/problem_set'
require 'exercism/solution'
require 'exercism/trail'
require 'exercism/assignment'
require 'exercism/curriculum'
require 'exercism/submission'
require 'exercism/input_sanitation'
require 'exercism/comment'
require 'exercism/locksmith'
require 'exercism/user'
require 'exercism/team'
require 'exercism/guest'
require 'exercism/null_submission'
require 'exercism/markdown'
require 'exercism/authentication'
require 'exercism/github'
require 'exercism/notification'
require 'exercism/breakdown'
require 'exercism/use_cases'

Mongoid.load!("./config/mongoid.yml")

class Exercism
  # See lib/exercism/curriculum.rb for default curriculum setup
end

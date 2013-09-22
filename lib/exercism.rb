require 'faraday'

require 'exercism/assignment'
require 'exercism/authentication'
require 'exercism/breakdown'
require 'exercism/code'
require 'exercism/comment'
require 'exercism/curriculum'
require 'exercism/exercise'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/locksmith'
require 'exercism/locale'
require 'exercism/markdown'
require 'exercism/notification'
require 'exercism/null_submission'
require 'exercism/problem_set'
require 'exercism/solution'
require 'exercism/submission'
require 'exercism/team'
require 'exercism/trail'
require 'exercism/use_cases'
require 'exercism/user'

Mongoid.load!("./config/mongoid.yml")

class Exercism
  # See lib/exercism/curriculum.rb for default curriculum setup
end

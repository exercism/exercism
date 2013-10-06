require 'active_support' # Must be required before active_record
require 'active_record'
require 'faraday'

require 'exercism/assignment'
require 'exercism/authentication'
require 'exercism/breakdown'
require 'exercism/code'
require 'exercism/cohort'
require 'exercism/comment'
require 'exercism/converts_markdown_to_html'
require 'exercism/curriculum'
require 'exercism/exercise'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/like'
require 'exercism/locksmith'
require 'exercism/locale'
require 'exercism/markdown'
require 'exercism/muted_submission'
require 'exercism/notification'
require 'exercism/null_submission'
require 'exercism/problem_set'
require 'exercism/solution'
require 'exercism/submission'
require 'exercism/submission_viewer'
require 'exercism/team'
require 'exercism/team_membership'
require 'exercism/trail'
require 'exercism/use_cases'
require 'exercism/user'

require 'db/connection'
DB::Connection.establish

class Exercism
  # See lib/exercism/curriculum.rb for default curriculum setup
end

require 'active_support' # Must be required before active_record
require 'active_record'
require 'faraday'

require 'exercism/config'
require 'exercism/alert'
require 'exercism/named'
require 'exercism/authentication'
require 'exercism/code'
require 'exercism/cohort'
require 'exercism/comment'
require 'exercism/converts_markdown_to_html'
require 'exercism/decaying_randomizer'
require 'exercism/exercise'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/like'
require 'exercism/look'
require 'exercism/markdown'
require 'exercism/muted_submission'
require 'exercism/nitstats'
require 'exercism/null_submission'
require 'exercism/submission'
require 'exercism/notification'
require 'exercism/submission_viewer'
require 'exercism/team'
require 'exercism/team_membership'
require 'exercism/team_manager'
require 'exercism/use_cases'
require 'exercism/user'
require 'exercism/user_exercise'
require 'exercism/work'
require 'exercism/log_entry'

require 'db/connection'
DB::Connection.establish

class Exercism
  def self.root
    File.expand_path('../..', __FILE__)
  end

  def self.relative_to_root(*paths)
    File.expand_path(File.join(root, *paths), __FILE__)
  end
end

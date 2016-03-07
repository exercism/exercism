require 'active_support' # Must be required before active_record
require 'active_record'
require 'faraday'

require_relative '../x/track'

require 'exercism/acl'
require 'exercism/assumable_user'
require 'exercism/named'
require 'exercism/authentication'
require 'exercism/cohort'
require 'exercism/comment'
require 'exercism/comment_thread'
require 'exercism/converts_markdown_to_html'
require 'exercism/daily_count'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/iteration'
require 'exercism/language'
require 'exercism/like'
require 'exercism/lifecycle_event'
require 'exercism/markdown'
require 'exercism/null_submission'
require 'exercism/problem'
require 'exercism/submission'
require 'exercism/stats'
require 'exercism/notification'
require 'exercism/team'
require 'exercism/team_membership'
require 'exercism/log_entry'
require 'exercism/team_manager'
require 'exercism/track_stream'
require 'exercism/use_cases'
require 'exercism/user'
require 'exercism/user_exercise'
require 'exercism/user_progression'
require 'exercism/user_track'
require 'exercism/unknown_language'
require 'exercism/view'
require 'exercism/language_track'
require 'exercism/user_lookup'
require 'exercism/daily'


require 'db/connection'
DB::Connection.establish

class Exercism
  def self.root
    File.expand_path('../..', __FILE__)
  end

  def self.relative_to_root(*paths)
    File.expand_path(File.join(root, *paths), __FILE__)
  end

  def self.uuid
    SecureRandom.uuid.tr('-', '')
  end
end

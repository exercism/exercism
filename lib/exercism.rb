require 'active_support' # Must be required before active_record
require 'active_record'
require 'faraday'

require 'exercism/acl'
require 'exercism/assumable_user'
require 'exercism/named'
require 'exercism/authentication'
require 'exercism/comment'
require 'exercism/converts_markdown_to_html'
require 'exercism/conversation_subscription'
require 'exercism/daily_count'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/iteration'
require 'exercism/language'
require 'exercism/like'
require 'exercism/markdown'
require 'exercism/null_submission'
require 'exercism/problem'
require 'exercism/submission'
require 'exercism/stats'
require 'exercism/stream'
require 'exercism/stream_exercise'
require 'exercism/stream_filter_item'
require 'exercism/notification'
require 'exercism/team'
require 'exercism/team_membership'
require 'exercism/team_membership_invite'
require 'exercism/team_membership_request'
require 'exercism/team_stream'
require 'exercism/team_stream_filters'
require 'exercism/team_manager'
require 'exercism/track_stream'
require 'exercism/track_stream_filters'
require 'exercism/use_cases'
require 'exercism/user'
require 'exercism/user_exercise'
require 'exercism/user_finished_tracks'
require 'exercism/user_tracks_summary'
require 'exercism/deleted_iterations'
require 'exercism/view'
require 'exercism/user_lookup'
require 'exercism/daily'
require 'exercism/tag'
require 'exercism/watermark'

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

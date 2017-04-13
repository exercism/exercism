require 'active_support' # Must be required before active_record
require 'active_record'
require 'faraday'

require_relative '../config/flipper'

require 'exercism/acl'
require 'exercism/assumable_user'
require 'exercism/authentication'
require 'exercism/client_version'
require 'exercism/comment'
require 'exercism/conversation_subscription'
require 'exercism/converts_markdown_to_html'
require 'exercism/daily'
require 'exercism/daily_count'
require 'exercism/deleted_iterations'
require 'exercism/github'
require 'exercism/guest'
require 'exercism/iteration'
require 'exercism/language'
require 'exercism/like'
require 'exercism/markdown'
require 'exercism/metrics'
require 'exercism/named'
require 'exercism/notification'
require 'exercism/null_submission'
require 'exercism/participation_stats'
require 'exercism/problem'
require 'exercism/stream'
require 'exercism/stream_exercise'
require 'exercism/stream_filter_item'
require 'exercism/submission'
require 'exercism/tag'
require 'exercism/team'
require 'exercism/team_manager'
require 'exercism/team_membership'
require 'exercism/team_membership_invite'
require 'exercism/team_membership_request'
require 'exercism/team_stream'
require 'exercism/team_stream_filters'
require 'exercism/track_stats'
require 'exercism/track_stream'
require 'exercism/track_stream_filters'
require 'exercism/use_cases'
require 'exercism/user'
require 'exercism/user_exercise'
require 'exercism/user_finished_tracks'
require 'exercism/user_lookup'
require 'exercism/user_tracks_summary'
require 'exercism/varied_responses'
require 'exercism/view'
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

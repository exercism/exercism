require "active_support" # Must be required before active_record
require "active_record"
require "faraday"

require "exercism/explore"

require "exercism/assumable_user"
require "exercism/onboarding"
require "exercism/progress_bar"
require "exercism/config"
require "exercism/alert"
require "exercism/named"
require "exercism/authentication"
require "exercism/code"
require "exercism/cohort"
require "exercism/comment"
require "exercism/comment_thread"
require "exercism/converts_markdown_to_html"
require "exercism/decaying_randomizer"
require "exercism/github"
require "exercism/guest"
require "exercism/iteration"
require "exercism/language"
require "exercism/like"
require "exercism/lifecycle_event"
require "exercism/look"
require "exercism/markdown"
require "exercism/muted_submission"
require "exercism/nitstats"
require "exercism/null_submission"
require "exercism/problem"
require "exercism/submission"
require "exercism/submission_status"
require "exercism/notification"
require "exercism/submission_viewer"
require "exercism/team"
require "exercism/team_membership"
require "exercism/team_manager"
require "exercism/use_cases"
require "exercism/user"
require "exercism/user_exercise"
require "exercism/work"
require "exercism/log_entry"
require "exercism/language_track"
require "exercism/user_lookup"
require "exercism/db_source"
require "exercism/github_source"
require "exercism/node"
require "pry" unless ENV["RACK_ENV"] == "production"

require "db/connection"
DB::Connection.establish
require "exercism/active_record_citext"

Github.configure_octokit

class Exercism
  def self.root
    File.expand_path("../..", __FILE__)
  end

  def self.relative_to_root(*paths)
    File.expand_path(File.join(root, *paths), __FILE__)
  end

  def self.uuid
    SecureRandom.uuid.tr("-", "")
  end
end

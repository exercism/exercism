require 'exercism/stats/submissions_sql'
require 'exercism/stats/streak'

module Stats
  module SubmissionStreak
    def self.for(username, year, month)
      user = User.find_by_username(username)
      data = Stats::SubmissionsSQL.new(user.id, year, month).execute
      Stats::Streak.new(Exercism::Config.languages.keys, data, year, month).to_h
    end
  end
end

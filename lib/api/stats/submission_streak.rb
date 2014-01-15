require 'api/stats/submissions_sql'
require 'api/stats/streak'

module Api
  module Stats
    module SubmissionStreak
      def self.for(username, year, month)
        user = User.find_by_username(username)
        data = Api::Stats::SubmissionsSQL.new(user.id, year, month).execute
        Api::Stats::Streak.new(Exercism.languages, data, year, month).to_h
      end
    end
  end
end

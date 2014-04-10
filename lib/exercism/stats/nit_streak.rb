require 'exercism/stats/nitpicks_sql'
require 'exercism/stats/streak'

module Stats
  module NitStreak
    def self.for(username, year, month)
      user = User.find_by_username(username)
      data = Stats::NitpicksSQL.new(user.id, year, month).execute
      Stats::Streak.new(Exercism::Config.languages, data, year, month).to_h
    end
  end
end

require 'date'
require './test/approval_helper'
require 'api/stats/streak'

class ApiStatsStreakTest < MiniTest::Unit::TestCase

  def data
    [
      {"count"=>"2", "language"=>"ruby", "date"=>"2013-12-01"},
      {"count"=>"1", "language"=>"python", "date"=>"2013-12-11"},
      {"count"=>"1", "language"=>"ruby", "date"=>"2013-12-31"}
    ]
  end

  def test_stats_by_language_and_date
    streak = Api::Stats::Streak.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(streak.by_language_and_date, name: 'stats_by_language_and_date')
  end

  def test_all_the_data
    streak = Api::Stats::Streak.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(streak.to_h, name: 'complete_streak_stats')
  end
end

require 'date'
require_relative '../../approval_helper'
require 'exercism/stats/streak'

class StatsStreakTest < Minitest::Test

  def data
    [
      {"count"=>"2", "language"=>"ruby", "date"=>"2013-12-01"},
      {"count"=>"1", "language"=>"python", "date"=>"2013-12-11"},
      {"count"=>"1", "language"=>"ruby", "date"=>"2013-12-31"}
    ]
  end

  def test_stats_by_language_and_date
    streak = Stats::Streak.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(streak.by_language_and_date, name: 'stats_by_language_and_date')
  end

  def test_all_the_data
    streak = Stats::Streak.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(streak.to_h, name: 'complete_streak_stats')
  end
end

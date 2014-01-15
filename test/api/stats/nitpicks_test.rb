require 'date'
require './test/approval_helper'
require 'api/stats/nitpicks'

class ApiStatsNitpicksTest < MiniTest::Unit::TestCase

  def data
    [
      {"nit_count"=>"2", "language"=>"ruby", "date"=>"2013-12-01"},
      {"nit_count"=>"1", "language"=>"python", "date"=>"2013-12-11"},
      {"nit_count"=>"1", "language"=>"ruby", "date"=>"2013-12-31"}
    ]
  end

  def test_stats_by_language_and_date
    stats = Api::Stats::Nitpicks.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(stats.by_language_and_date, name: 'nit_stats_by_language_and_date')
  end

  def test_all_the_data
    stats = Api::Stats::Nitpicks.new([:ruby, :python, :go], data, 2013, 12)
    Approvals.verify(stats.to_h, name: 'complete_nit_stats')
  end
end

require_relative '../../test_helper'
require_relative '../../../app/helpers/fuzzy_time'

class FuzzyTimeHelperTest < Minitest::Test

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::FuzzyTime)
    def @helper.now
      Time.utc(2013, 1, 2, 3, 4)
    end
    @helper
  end

  def now
    @now ||= Time.utc(2013, 1, 2, 3, 4)
  end

  def test_less_than_2_minutes_ago
    ago = helper.ago(now-119)
    assert_equal "just now", ago
  end

  def test_less_than_55_minutes_ago
    ago = helper.ago(now-(54*60))
    assert_equal "about 54 minutes ago", ago
  end

  def test_less_than_80_minutes_ago
    ago = helper.ago(now-(79*60))
    assert_equal "about an hour ago", ago
  end

  def test_less_than_105_minutes_ago
    ago = helper.ago(now-(104*60))
    assert_equal "about an hour and a half ago", ago
  end

  def test_less_than_23_hours_ago
    ago = helper.ago(now-(23*60*60)+1)
    assert_equal "about 23 hours ago", ago
  end

  def test_a_bit_more_than_23_hours_ago
    ago = helper.ago(now-(23*60*60 + 29*60))
    assert_equal "about 23 hours ago", ago
  end

  def test_about_a_day_ago
    ago = helper.ago(now-(36*60*60)+1)
    assert_equal "about a day ago", ago
  end

  def test_days_ago
    ago = helper.ago(now-(20*24*60*60)+1)
    assert_equal "about 20 days ago", ago
  end

  def test_weeks_ago
    ago = helper.ago(now-(10*7*24*60*60))
    assert_equal "about 10 weeks ago", ago
  end

  def test_months_ago
    ago = helper.ago(now-(12*7*24*60*60))
    assert_equal "about 3 months ago", ago
  end

  def test_not_quite_a_year_ago
    ago = helper.ago(now-(340*24*60*60))
    assert_equal "about 11 months ago", ago
  end

  def test_about_a_year_ago
    ago = helper.ago(now-(15*30*24*60*60))
    assert_equal "about a year ago", ago
  end

  def test_ages_ago
    ago = helper.ago(now-(20*30*24*60*60))
    assert_equal "ages ago", ago
  end
end

require './test/test_helper'
require 'app/helpers/fuzzy_time_helper'

class FuzzyTimeHelperTest < MiniTest::Unit::TestCase

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::FuzzyTimeHelper)
    @helper
  end

  def now
    Time.utc(2013, 1, 2, 3, 4)
  end

  def test_less_than_2_minutes_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-119)
      assert_equal "just now", ago
    end
  end

  def test_less_than_55_minutes_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(54*60))
      assert_equal "about 54 minutes ago", ago
    end
  end

  def test_less_than_80_minutes_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(79*60))
      assert_equal "about an hour ago", ago
    end
  end

  def test_less_than_105_minutes_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(104*60))
      assert_equal "about an hour and a half ago", ago
    end
  end

  def test_less_than_23_hours_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(23*60*60)+1)
      assert_equal "about 23 hours ago", ago
    end
  end

  def test_about_a_day_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(36*60*60)+1)
      assert_equal "about a day ago", ago
    end
  end

  def test_days_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(20*24*60*60)+1)
      assert_equal "about 20 days ago", ago
    end
  end

  def test_weeks_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(10*7*24*60*60))
      assert_equal "about 10 weeks ago", ago
    end
  end

  def test_months_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(12*7*24*60*60))
      assert_equal "about 3 months ago", ago
    end
  end

  def test_not_quite_a_year_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(340*24*60*60))
      assert_equal "about 11 months ago", ago
    end
  end

  def test_about_a_year_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(15*30*24*60*60))
      assert_equal "about a year ago", ago
    end
  end

  def test_ages_ago
    helper.stub(:now, now) do
      ago = helper.ago(now-(20*30*24*60*60))
      assert_equal "ages ago", ago
    end
  end
end

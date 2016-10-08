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

  def link_text(date, link_text)
    "<span data-toggle='tooltip' data-title='#{date.strftime('%e %B %Y at %H:%M %Z')}'>#{link_text}</span>"
  end

  def test_less_than_2_minutes_ago
    ago = helper.ago(now - 119)
    assert_equal link_text(now - 119, "just now"), ago
  end

  def test_less_than_55_minutes_ago
    ago = helper.ago(now - (54 * 60))
    assert_equal link_text(now - (54 * 60), "about 54 minutes ago"), ago
  end

  def test_less_than_80_minutes_ago
    ago = helper.ago(now - (79 * 60))
    assert_equal link_text(now - (79 * 60), "about an hour ago"), ago
  end

  def test_less_than_105_minutes_ago
    ago = helper.ago(now - (104 * 60))
    assert_equal link_text(now - (104 * 60), "about an hour and a half ago"), ago
  end

  def test_less_than_23_hours_ago
    ago = helper.ago(now - (23 * 60 * 60) + 1)
    assert_equal link_text(now - (23 * 60 * 60) + 1, "about 23 hours ago"), ago
  end

  def test_a_bit_more_than_23_hours_ago
    more_than_23_hours = (23 * 60 * 60 + 29 * 60)
    ago = helper.ago(now - more_than_23_hours)
    assert_equal link_text(now - more_than_23_hours, "about 23 hours ago"), ago
  end

  def test_a_bit_more_than_23_hours_and_a_half_ago
    more_than_23_hours_and_a_half = (23 * 60 * 60 + 45 * 60)
    ago = helper.ago(now - more_than_23_hours_and_a_half)
    assert_equal link_text(now - more_than_23_hours_and_a_half, "about 24 hours ago"), ago
  end

  def test_bit_more_than_a_day
    ago = helper.ago(now - (24 * 60 * 60 + 29 * 60))
    assert_equal "<span class='localize-time'> 1 January 2013 at 02:35 UTC</span>", ago
  end

  def test_ages_ago
    ago = helper.ago(now - (20 * 30 * 24 * 60 * 60))
    assert_equal "<span class='localize-time'>13 May 2011 at 03:04 UTC</span>", ago
  end
end

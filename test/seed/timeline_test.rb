require './test/test_helper'
require 'time'
require 'seed/timeline'

class SeedTimelineTest < Minitest::Test
  def test_small_number_of_events
    timeline = Seed::Timeline.new(3)
    assert_equal 3, timeline.events.size
    assert timeline.events.first < timeline.events.last
  end

  def test_larger_number_of_events
    timeline = Seed::Timeline.new(10)
    assert_equal 10, timeline.events.size
    assert timeline.events.first < timeline.events.last
  end
end


require_relative '../integration_helper'
require_relative '../../lib/exercism/lifecycle_event'

class LifecycleEventTest < Minitest::Test
  include DBCleaner

  def test_tracks_successfully
    now = Time.utc(2013, 1, 1, 2, 3, 5)
    LifecycleEvent.track('something', 1, now)
    assert_equal 1, LifecycleEvent.count
    event = LifecycleEvent.first
    assert_equal 'something', event.key
    assert_equal 1, event.user_id
    assert_equal now, event.happened_at
  end

  def test_tracks_multiple_events_successfully
    now = Time.utc(2013, 1, 1, 2, 3, 5)
    LifecycleEvent.track('something', 1, now)
    LifecycleEvent.track('something_else', 1, now+5.minutes)

    assert_equal 2, LifecycleEvent.count
    event1 = LifecycleEvent.find_by(key: 'something')
    event2 = LifecycleEvent.find_by(key: 'something_else')

    assert_equal 'something', event1.key
    assert_equal 1, event1.user_id
    assert_equal now, event1.happened_at

    assert_equal 'something_else', event2.key
    assert_equal 1, event2.user_id
    assert_equal now+5.minutes, event2.happened_at
  end

  def test_does_not_track_duplicate
    now = Time.utc(2013, 1, 1, 2, 3, 5)
    LifecycleEvent.track('stuff', 1, now)
    LifecycleEvent.track('stuff', 1, now+5.minutes)

    assert_equal 1, LifecycleEvent.count
    event = LifecycleEvent.first
    assert_equal 'stuff', event.key
    assert_equal 1, event.user_id
    assert_equal now, event.happened_at
  end

  def test_ignores_guest_user
    LifecycleEvent.track('whatever', nil)
    assert_equal 0, LifecycleEvent.count
  end
end

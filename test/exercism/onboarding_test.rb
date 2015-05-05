require_relative '../test_helper'
require_relative '../../lib/exercism/onboarding'
require_relative '../../lib/exercism/progress_bar'

class OnboardingTest < Minitest::Test
  def test_status_of_guest
    assert_equal 'guest', Onboarding.status([])
    assert_equal(-1, Onboarding.step([]))
  end

  def test_status_at_the_start
    events = %w(joined)
    assert_equal 'joined', Onboarding.status(events)
    assert_equal 0, Onboarding.step(events)
  end

  def test_status_at_the_end
    events = %w(joined fetched submitted received_feedback completed commented)
    assert_equal 'commented', Onboarding.status(events)
    assert_equal 5, Onboarding.step(events)
  end

  def test_status_if_fetched_after_submitted
    events = %w(joined submitted fetched)
    assert_equal 'submitted', Onboarding.status(events)
    assert_equal 2, Onboarding.step(events)
  end

  def test_next_action
    events = %w(joined)
    assert_equal 'install-cli', Onboarding.next_action(events)

    events = %w(joined fetched)
    assert_equal 'submit-code', Onboarding.next_action(events)

    events = %w(joined fetched submitted)
    assert_equal 'have-a-conversation', Onboarding.next_action(events)

    events = %w(joined fetched submitted received_feedback)
    assert_equal 'have-a-conversation', Onboarding.next_action(events)

    events = %w(joined fetched submitted received_feedback completed)
    assert_equal 'pay-it-forward', Onboarding.next_action(events)

    events = %w(joined fetched submitted received_feedback completed)
    assert_equal 'pay-it-forward', Onboarding.next_action(events)

    events = %w(joined fetched submitted received_feedback completed commented)
    assert_equal 'explore', Onboarding.next_action(events)

    events = %w(joined fetched submitted received_feedback completed commented onboarded)
    assert_equal 'explore', Onboarding.next_action(events)
  end
end

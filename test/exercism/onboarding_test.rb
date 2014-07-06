require_relative '../test_helper'
require_relative '../../lib/exercism/onboarding'

class OnboardingTest < Minitest::Test
  def test_status_at_the_start
    assert_equal 'joined', Onboarding.status(%w(joined))
  end

  def test_status_at_the_end
    steps = %w(joined fetched submitted received_feedback completed commented)
    assert_equal 'commented', Onboarding.status(steps)
  end

  def test_status_if_fetched_after_submitted
    steps = %w(joined submitted fetched)
    assert_equal 'submitted', Onboarding.status(steps)
  end
end

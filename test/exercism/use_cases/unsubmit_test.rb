require './test/integration_helper'

class NitpickTest < Minitest::Test

  def test_success
    bob = User.create(username: 'bob')
    bob.submissions.create(:user => bob)
    Unsubmit.new(bob).unsubmit

    assert_equal 0, bob.submissions.count
  end

  def test_fails_when_no_submission
    bob = User.create(username: 'bob')
    assert_raises Unsubmit::NothingToUnsubmit do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_already_nitpicked
    bob = User.create(username: 'bob')
    submission = bob.submissions.create(:user => bob)
    submission.nits.create

    assert_raises Unsubmit::SubmissionHasNits do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_already_approved
    bob = User.create(username: 'bob')
    bob.submissions.create(:user => bob, :state => "approved")

    assert_raises Unsubmit::SubmissionApproved do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_too_old
    bob = User.create(username: 'bob')
    bob.submissions.create(:user => bob, :at => Time.now - Unsubmit::TIMEOUT - 1)

    assert_raises Unsubmit::SubmissionTooOld do
      Unsubmit.new(bob).unsubmit
    end
  end

end
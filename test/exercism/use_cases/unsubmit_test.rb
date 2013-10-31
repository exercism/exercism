require './test/integration_helper'

class UnsubmitTest < Minitest::Test
  include DBCleaner

  def teardown
    super
    @bob = nil
  end

  def bob
    @bob ||= User.create(username: 'bob')
  end

  def test_success
    submission = bob.submissions.create
    Unsubmit.new(bob).unsubmit

    assert_equal 0, bob.submissions.count
  end

  def test_fails_when_no_submission
    assert_raises Unsubmit::NothingToUnsubmit do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_already_nitpicked
    alice = User.create(username: 'alice')
    submission = bob.submissions.create
    submission.comments.create(user: alice, body: "foobar")

    assert_raises Unsubmit::SubmissionHasNits do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_already_done
    bob.submissions.create(:state => "done")

    assert_raises Unsubmit::SubmissionDone do
      Unsubmit.new(bob).unsubmit
    end
  end

  def test_fails_when_too_old
    bob.submissions.create(:created_at => Time.now - Unsubmit::TIMEOUT - 1)

    assert_raises Unsubmit::SubmissionTooOld do
      Unsubmit.new(bob).unsubmit
    end
  end
end

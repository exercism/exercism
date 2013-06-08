require './test/mongo_helper'
require 'exercism/submission'

class SubmissionTest < MiniTest::Unit::TestCase

  def test_supercede_pending_submission
    submission = Submission.new(state: 'pending')
    submission.supercede!
    assert_equal 'superceded', submission.reload.state
  end

  def test_do_not_supercede_approved_submissions
    submission = Submission.new(state: 'approved')
    submission.supercede!
    assert_equal 'approved', submission.state
  end

  def test_approve_sets_the_state
    nong = Locale.new('nong', 'no', 'not')
    trail = Trail.new(nong, %w(one two), '/tmp')
    alice = User.new(github_id: 1)
    submission = Submission.create(user: alice, slug: 'one', language: 'nong')
    admin = User.new(github_id: 2)
    submission.approved!(admin, trail)
    assert submission.reload.approved?
  end

end


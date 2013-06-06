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

end


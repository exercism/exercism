require './test/mongo_helper'
require 'exercism/submission'
require "mocha/setup"

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

  def test_retrieve_assignment
    # Crazy long path. Best I can figure there's no storage of the path past the
    # Curriculum object in Exercism so we have to mock the whole chain
    trail = mock()
    Exercism.stubs(:current_curriculum => mock(:trails => trail))
    trail.expects(:[]).with('ruby').returns(mock(:assign => mock(:example => "say 'one'")))

    submission = Submission.new(slug: 'bob', language: 'ruby')
    assert_equal("say 'one'", submission.assignment.example)
  end

end


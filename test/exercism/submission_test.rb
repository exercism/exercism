require './test/mongo_helper'
require 'exercism/exercise'
require 'exercism/nit'
require 'exercism/user'
require 'exercism/submission'
require "mocha/setup"

class Exercism
end

class SubmissionTest < Minitest::Test

  def teardown
    Mongoid.reset
  end

  def test_supersede_pending_submission
    submission = Submission.new(state: 'pending')
    submission.supersede!
    assert_equal 'superseded', submission.reload.state
  end

  def test_do_not_supersede_approved_submissions
    submission = Submission.new(state: 'approved')
    submission.supersede!
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

  def test_iteration_counts
    alice = User.new(username: 'alice')
    s1 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s2 = Submission.create(state: 'superseded', user: alice, language: 'nong', slug: 'one')
    s3 = Submission.create(state: 'pending', user: alice, language: 'nong', slug: 'one')

    [s1, s2, s3].each do |submission|
      assert_equal 3, submission.versions_count
    end

    assert_equal 1, s1.version
    assert_equal 2, s2.version
    assert_equal 3, s3.version
  end

end


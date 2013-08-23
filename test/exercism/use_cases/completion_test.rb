require './test/integration_helper'
require './test/fixtures/fake_curricula'

class CompletionTest < Minitest::Test

  attr_reader :submission, :user, :curriculum
  def setup
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add FakeCurriculum.new
    @user = User.create(username: 'bob', current: {'fake' => 'one'}, github_id: 1)

    attempt = Attempt.new(user, 'CODE', 'one/one.ext', curriculum).save
    @submission = Submission.first
  end

  def teardown
    Mongoid.reset
  end

  def test_complete_a_submission
    Completion.new(submission, curriculum).save
    submission.reload
    assert_equal 'approved', submission.state
    assert !submission.approved_at.nil?

    user.reload
    done = {'fake' => ['one']}
    assert_equal done, user.completed
  end

  def test_approve_last_submission_on_trail_gives_a_dummy_assignment
    Completion.new(submission, curriculum).save
    attempt = Attempt.new(user.reload, 'CODE', 'two/two.ext', curriculum).save
    submission = Submission.last
    Completion.new(submission, curriculum).save
    assert_equal 'congratulations', submission.reload.user.current_in('fake').slug
  end
end


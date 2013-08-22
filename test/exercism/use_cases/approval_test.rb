require './test/integration_helper'
require './test/fixtures/fake_curricula'

class ApprovalTest < Minitest::Test

  attr_reader :submission, :locksmith, :user, :curriculum
  def setup
    @curriculum = Curriculum.new('/tmp')
    @curriculum.add FakeCurriculum.new
    @locksmith = User.create(username: 'alice', github_id: 1, mastery: ['fake'])
    @user = User.create(username: 'bob', current: {'fake' => 'one'}, github_id: 2)

    attempt = Attempt.new(user, 'CODE', 'one/one.ext', curriculum).save
    @submission = Submission.first
  end

  def teardown
    Mongoid.reset
  end

  def test_approve_a_submission_sets_the_state
    Approval.new(submission.id, locksmith, nil, curriculum).save
    submission.reload
    assert_equal 'approved', submission.state
  end

  def test_approve_submission_sets_approval_time
    Approval.new(submission.id, locksmith, nil, curriculum).save
    submission.reload
    assert !submission.approved_at.nil?
  end

  def test_approve_submission_sets_approver
    Approval.new(submission.id, locksmith, nil, curriculum).save
    submission.reload
    assert_equal locksmith, submission.approver
  end

  def test_approve_submission_saves_comment
    Approval.new(submission.id, locksmith, 'very nice', curriculum).save
    submission.reload
    assert_equal 'very nice', submission.comments.first.comment
  end

  def test_approve_submission_with_empty_comment_leaves_comment_off
    Approval.new(submission.id, locksmith, '', curriculum).save
    submission.reload
    assert_equal [], submission.comments
  end

  def test_approve_submission_sets_completed_assignments
    Approval.new(submission.id, locksmith, nil, curriculum).save
    user.reload
    done = {'fake' => ['one']}
    assert_equal done, user.completed
  end

  def test_approve_last_submission_on_trail_gives_a_dummy_assignment
    Approval.new(submission.id, locksmith, nil, curriculum).save
    attempt = Attempt.new(user.reload, 'CODE', 'two/two.ext', curriculum).save
    submission = Submission.last
    approval = Approval.new(submission.id, locksmith, nil, curriculum).save
    assert_equal 'congratulations', approval.submitter.current_in('fake').slug
  end
end


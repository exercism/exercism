require './test/integration_helper'

class ApprovalTest < MiniTest::Unit::TestCase

  attr_reader :submission, :admin, :user, :curriculum
  def setup
    @curriculum = Curriculum.new('/tmp')
    nong = Locale.new('nong', 'no', 'not')
    @curriculum.add(nong, ['one', 'two'])
    @user = User.create(username: 'allison', current: {'nong' => 'one'})

    attempt = Attempt.new(user, 'CODE', 'one.no', curriculum).save
    @submission = Submission.first
    @admin = User.create(username: 'burtlo', github_id: 2)
  end

  def teardown
    Mongoid.reset
  end

  def test_approve_a_submission_sets_the_state
    Approval.new(submission.id, admin, nil, curriculum).save
    submission.reload
    assert_equal 'approved', submission.state
  end

  def test_approve_submission_sets_approval_time
    Approval.new(submission.id, admin, nil, curriculum).save
    submission.reload
    assert !submission.approved_at.nil?
  end

  def test_approve_submission_sets_approver
    Approval.new(submission.id, admin, nil, curriculum).save
    submission.reload
    assert_equal admin, submission.approver
  end

  def test_approve_submission_saves_comment
    Approval.new(submission.id, admin, 'very nice', curriculum).save
    submission.reload
    assert_equal 'very nice', submission.nits.first.comment
  end

  def test_approve_submission_sets_completed_assignments
    Approval.new(submission.id, admin, nil, curriculum).save
    user.reload
    done = {'nong' => ['one']}
    assert_equal done, user.completed
  end

  def test_approve_last_submission_on_trail_gives_a_dummy_assignment
    Approval.new(submission.id, admin, nil, curriculum).save
    attempt = Attempt.new(user, 'CODE', 'two.no', curriculum).save
    submission = Submission.last
    approval = Approval.new(submission.id, admin, nil, curriculum).save
    assert_equal 'congratulations', approval.submitter.current_on('nong').slug
  end
end


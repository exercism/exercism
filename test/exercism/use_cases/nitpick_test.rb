require './test/integration_helper'

class NitpickTest < Minitest::Test

  def exercise
    Exercise.new('nong', 'one')
  end

  def submission
    return @submission if @submission

    @submission = Submission.on(exercise)
    @submission.user = User.create(username: 'bob')
    @submission.save
    @submission
  end

  def teardown
    Mongoid.reset
    @bob = nil
    @submission = nil
  end

  def test_nitpicking_a_submission_saves_a_nit
    nitpicker = User.new(username: 'alice')
    Nitpick.new(submission.id, nitpicker, 'Too many variables').save
    nit = submission.reload.comments.first
    assert submission.pending?, "Should be pending"
    assert_equal 'Too many variables', nit.comment
    assert !submission.approvable?, "Should NOT be approvable"
  end

  def test_empty_nit_does_not_get_saved
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, '').save
    assert !nitpick.nitpicked?
    assert_equal 0, submission.reload.comments.count
  end

  def test_flag_a_submission_for_approval
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'Too many variables', approvable: true).save
    assert nitpick.nitpicked?
    submission.reload
    assert submission.approvable?
    assert_equal ['alice'], submission.flagged_by
    assert submission.pending?
  end

  def test_can_flag_without_comment
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, '', approvable: true).save
    submission.reload
    assert submission.approvable?, "Expected assignment to be flagged"
    assert_equal ['alice'], submission.flagged_by
    assert submission.pending?
  end

  def test_nitpicking_hibernating_exercise_sets_it_to_pending
    submission.state = 'hibernating'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.pending?
  end

  def test_do_not_change_state_of_approved_submission
    submission.state = 'approved'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.approved?
  end

  def test_do_not_change_state_of_superseded_submission
    submission.state = 'superseded'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.superseded?
  end
end

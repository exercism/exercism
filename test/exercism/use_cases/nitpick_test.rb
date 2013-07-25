require './test/integration_helper'

class NitpickTest < Minitest::Test

  def teardown
    Mongoid.reset
  end

  def test_nitpicking_a_submission_saves_a_nit
    exercise = Exercise.new('nong', 'one')
    submission = Submission.on(exercise)
    nitpicker = User.new(username: 'alice')
    Nitpick.new(submission.id, nitpicker, 'Too many variables', approvable: nil).save
    nit = submission.reload.nits.first
    assert submission.pending?, "Should be pending"
    assert_equal 'Too many variables', nit.comment
    assert !submission.approvable?, "Should NOT be approvable"
  end

  def test_flag_a_submission_for_approval
    exercise = Exercise.new('nong', 'one')
    submission = Submission.on(exercise)
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'Too many variables', approvable: true).save
    assert nitpick.nitpicked?
    submission = submission.reload
    assert submission.approvable?
    assert_equal ['alice'], submission.flagged_by
    assert submission.pending?
  end

  def test_empty_nit_does_not_get_saved
    exercise = Exercise.new('nong', 'one')
    submission = Submission.on(exercise)
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, '').save
    assert !nitpick.nitpicked?
    assert_equal 0, submission.reload.nits.count
  end

end

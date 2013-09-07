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
    refute submission.liked?, "Should NOT be liked"
  end

  def test_nitpicking_a_submission_mutes_it
    nitpicker = User.new(username: 'alice')
    Nitpick.new(submission.id, nitpicker, 'Too many variables').save
    assert submission.reload.muted_by?(nitpicker), 'should be muted'
  end

  def test_empty_nit_does_not_get_saved
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, '').save
    assert !nitpick.nitpicked?
    assert_equal 0, submission.reload.comments.count
  end

  def test_empty_nit_does_not_mute
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, '').save
    refute submission.reload.muted_by?(nitpicker)
  end

  def test_nitpicking_hibernating_exercise_sets_it_to_pending
    submission.state = 'hibernating'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.pending?
  end

  def test_do_not_change_state_of_completed_submission
    submission.state = 'done'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.done?
  end

  def test_do_not_change_state_of_superseded_submission
    submission.state = 'superseded'
    submission.save
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, 'a comment').save
    submission.reload
    assert submission.superseded?
  end

  def test_nitpick_with_mentions
    nitpicker = User.new(username: 'alice')
    nitpick = Nitpick.new(submission.id, nitpicker, "Mention @#{@submission.user.username}").save
    submission.reload
    comment = submission.comments.last
    assert_equal 1, comment.mentions.count
    assert_equal submission.user, comment.mentions.first
  end
end

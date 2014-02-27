require './test/integration_helper'

class UserExerciseTest < MiniTest::Unit::TestCase
  include DBCleaner

  def test_close_an_exercise
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, state: 'pending')
    exercise.submissions << Submission.create(user: alice) # temporary measure
    assert exercise.open?
    exercise.close!
    refute exercise.reload.open?
  end

  def test_reopen_an_exercise
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, state: 'done')
    exercise.submissions << Submission.create(user: alice) # temporary measure
    assert exercise.closed?
    exercise.reopen!
    refute exercise.reload.closed?
  end
end


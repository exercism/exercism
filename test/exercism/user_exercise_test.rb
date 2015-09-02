require_relative '../integration_helper'

class UserExerciseTest < Minitest::Test
  include DBCleaner

  def test_reopen_an_exercise
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, state: 'done')
    exercise.submissions << Submission.create(user: alice) # temporary measure
    assert exercise.closed?
    exercise.reopen!
    exercise.reload
    refute exercise.closed?
    refute exercise.archived
  end

  def test_nit_count
    alice = User.create!(username: 'alice')
    exercise = UserExercise.create!(
        user: alice,
        state: 'done',
        submissions: [
            Submission.create!(user: alice, nit_count: 5),
            Submission.create!(user: alice, nit_count: 7)
        ]
    )

    exercise.reload
    assert_equal 12, exercise.nit_count
  end
end


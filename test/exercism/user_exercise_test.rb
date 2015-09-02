require_relative '../integration_helper'

class UserExerciseTest < Minitest::Test
  include DBCleaner

  def test_archive_and_unarchive
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, state: 'pending', archived: false)
    exercise.submissions << Submission.create(user: alice) # temporary measure
    refute exercise.archived?

    exercise.archive!
    exercise.reload
    assert exercise.archived?

    exercise.unarchive!
    exercise.reload
    refute exercise.archived?
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


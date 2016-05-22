require_relative '../integration_helper'

class UserExerciseTest < Minitest::Test
  include DBCleaner

  # rubocop:disable Metrics/AbcSize
  def test_archive_and_unarchive
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, archived: false)
    exercise.submissions << Submission.create(user: alice) # temporary measure
    refute exercise.archived?

    exercise.archive!
    exercise.reload
    assert exercise.archived?

    exercise.unarchive!
    exercise.reload
    refute exercise.archived?
  end
  # rubocop:enable Metrics/AbcSize

  def test_current
    alice = User.create(username: 'alice')
    closure_1 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1)
    ruby_1 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1)
    closure_2 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1)
    ruby_2 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1)
    assert_equal UserExercise.current, [closure_1, closure_2, ruby_1, ruby_2]
  end

  def test_decrement_iteration_count
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(iteration_count: 2, user: alex)
    exercise.decrement_iteration_count!
    assert_equal exercise.iteration_count, 1
  end
end

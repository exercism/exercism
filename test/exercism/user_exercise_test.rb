require_relative '../integration_helper'

class UserExerciseTest < Minitest::Test
  include DBCleaner

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

  def test_adding_help_for_current_users_exercise
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(user: alex)
    exercise.request_for_help!(alex)
    assert_equal exercise.help_requested?, true
  end

  def test_cannot_add_help_request_for_other_users_exercise
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(user: alex)
    alice = User.create(username: 'alice')
    exercise.request_for_help!(alice)
    assert_equal exercise.help_requested?, false
  end

  def test_removing_help_for_current_users_exercise
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(user: alex)
    alice = User.create(username: 'alice')
    exercise.remove_request_for_help!(alice)
    refute exercise.help_requested?
  end
end

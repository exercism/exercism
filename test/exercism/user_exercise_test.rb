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
    now = Time.now
    alice = User.create(username: 'alice')
    closure_1 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1, last_iteration_at: now - 40)
    ruby_1 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1, last_iteration_at: now - 30)
    closure_2 = UserExercise.create(user: alice, archived: false, language: 'closure', iteration_count: 1, last_iteration_at: now - 20)
    ruby_2 = UserExercise.create(user: alice, archived: false, language: 'ruby', iteration_count: 1, last_iteration_at: now - 10)
    assert_equal UserExercise.current, [ruby_2, closure_2, ruby_1, closure_1]
  end

  def test_decrement_iteration_count
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(iteration_count: 2, user: alex)
    exercise.decrement_iteration_count!
    assert_equal exercise.iteration_count, 1
  end

  def test_submitting_help_for_exercise
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(user: alex, help_requested: false)
    exercise.request_help!
    assert exercise.help_requested?
  end

  def test_cancelling_help_for_exercise
    alex = User.create(username: 'alex')
    exercise = UserExercise.create(user: alex, help_requested: true)
    exercise.cancel_request_for_help!
    refute exercise.help_requested?
  end

end

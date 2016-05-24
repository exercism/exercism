require_relative '../integration_helper'

class DeletedIterationsTest < Minitest::Test
  include DBCleaner

  def test_store_iterations
    alice = User.create(username: 'alice')
    exercise = UserExercise.create(user: alice, archived: false)
    submission = Submission.create(user: alice)
    exercise.submissions << submission
    DeletedIterations.store_iterations(exercise, alice.id)
    actual = DeletedIterations.find_by(user_id: alice.id)

    assert_equal DeletedIterations.count, 1
    assert_equal actual.submission, submission
    assert_equal actual.user, alice
  end
end

require_relative '../app_helper'

class AppExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def test_excercises_by_key
    alice = User.create(username: 'alice', github_id: 1)
    exercise = UserExercise.create(user: alice, language: 'go', slug: 'one', state: 'done')
    submission = Submission.create(user: alice, language: 'go', slug: 'bob', user_exercise: exercise)

    get "/exercises/#{exercise.key}", {}, login(alice)
    assert_equal 302, last_response.status
    location = "http://example.org/submissions/#{submission.key}"
    assert_equal location, last_response.location, "Wrong redirect for GET exercises"
  end

  def test_archive_and_unarchive
    alice = User.create(username: 'alice', github_id: 1)
    exercise = UserExercise.create(user: alice, language: 'go', slug: 'one', state: 'pending')
    submission = Submission.create(user: alice, language: 'go', slug: 'one', user_exercise: exercise, state: 'pending')

    post "/exercises/#{exercise.key}/archive", {}, login(alice)
    assert exercise.reload.archived?

    post "/exercises/#{exercise.key}/unarchive", {}, login(alice)
    refute exercise.reload.archived?
  end
end

require_relative '../app_helper'

class AppExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  attr_reader :alice, :exercise, :exercise_2, :submission

  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    @exercise = UserExercise.create(user: alice, language: 'go', slug: 'one',
                                    last_activity_at: Date.today, iteration_count: 1)
    @submission = Submission.create(user: alice, language: 'go',
                                    slug: 'one', user_exercise: exercise)

    @exercise_2 = UserExercise.create(user: alice, language: 'ruby', slug: 'two',
                                    last_activity_at: Date.today, iteration_count: 1)
  end

  def test_exercises_by_key
    get "/exercises/#{exercise.key}", {}, login(alice)
    assert_equal 302, last_response.status
    location = "http://example.org/submissions/#{submission.key}"
    assert_equal location, last_response.location, "Wrong redirect for GET exercises"
  end

  def test_archive_and_unarchive
    post "/exercises/#{exercise.key}/archive", {}, login(alice)
    assert exercise.reload.archived?

    post "/exercises/#{exercise.key}/unarchive", {}, login(alice)
    refute exercise.reload.archived?
  end

  def test_bulk_archive
    post "/exercises/archive", { exercise_ids: [exercise.id, exercise_2.id] }, login(alice)
    assert exercise.reload.archived?
    assert exercise_2.reload.archived?
  end

  def test_bulk_delete
    post "/exercises/delete", { exercise_ids: [exercise.id, exercise_2.id] }, login(alice)
    assert_equal 0, UserExercise.count
  end
end

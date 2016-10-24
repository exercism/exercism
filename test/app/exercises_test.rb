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
                                    last_activity_at: Date.today, iteration_count: 1, help_requested: false)
    @submission = Submission.create(user: alice, language: 'go',
                                    slug: 'one', user_exercise: exercise)

    @exercise_2 = UserExercise.create(user: alice, language: 'ruby', slug: 'two',
                                    last_activity_at: Date.today, iteration_count: 1, help_requested: true)
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

  def test_request_help_for_exercise
    post "/exercises/#{exercise.key}/request-for-help", {}, login(alice)
    assert exercise.reload.help_requested
  end

  def test_remove_request_for_help
    delete "/exercises/#{exercise_2.key}/request-for-help", {}, login(alice)
    refute exercise_2.reload.help_requested
  end

  def test_redirect_to_readme
    get "/exercises/#{exercise_2.language}/#{exercise_2.slug}"

    assert_equal "http://example.org/exercises/#{exercise_2.language}/#{exercise_2.slug}/readme", last_response.location, "Toplevel exercise url should redirect to README"
  end

  def test_exercise_readme
    get "/exercises/fake/hello-world/readme"

    assert_equal 200, last_response.status
    assert_match "Hello World in Fake", last_response.body
    assert_match "Oh, hello", last_response.body
  end

  def test_exercise_testsuite
    get "/exercises/fake/hello-world/test-suite"

    assert_equal 200, last_response.status
    assert_match "Hello World in Fake", last_response.body
    assert_match "assert 'hello'", last_response.body
  end
end

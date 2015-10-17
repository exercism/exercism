require_relative '../app_helper'

class AppExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  attr_reader :alice, :exercise, :submission

  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    @exercise = UserExercise.create(user: alice, language: 'go', slug: 'one',
                                    last_activity_at: Date.today, iteration_count: 1)
    @submission = Submission.create(user: alice, language: 'go',
                                    slug: 'one', user_exercise: exercise)
  end

  def test_exercises_next
    bob = User.create(username: 'bob', github_id: 1)
    next_exercise = UserExercise.create(user: bob, language: 'go', slug: 'one',
                                        last_activity_at: Date.yesterday,
                                        iteration_count: 1)
    ACL.create(user_id: alice.id, language: 'go', slug: 'one')

    get "/exercises/next?language=go", {}, login(alice)
    assert_equal 302, last_response.status
    location = "http://example.org/exercises/#{next_exercise.key}"
    assert_equal location, last_response.location, "Expected to be redirected to the next Go exercise"
  end

  def test_excercises_by_key
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
end

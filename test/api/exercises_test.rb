require_relative '../api_helper'

class ExercisesApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_exercises_gives_reasonable_empty_state
    get '/exercises'
    assert_equal 200, last_response.status
    assert_equal '{}', last_response.body
  end

  def test_exercises
    alice = User.create(username: 'alice', github_id: 1)

    UserExercise.create(user: alice, language: 'go', slug: 'one', iteration_count: 1, archived: true)
    UserExercise.create(user: alice, language: 'go', slug: 'two', skipped_at: Time.now)
    UserExercise.create(user: alice, language: 'go', slug: 'three', iteration_count: 1)
    UserExercise.create(user: alice, language: 'ruby', slug: 'one', iteration_count: 1, fetched_at: Time.now)
    UserExercise.create(user: alice, language: 'ruby', slug: 'two', fetched_at: Time.now)

    get '/exercises', key: alice.key

    output = last_response.body
    options = { format: :json, name: 'api_exercises' }
    Approvals.verify(output, options)
  end
end

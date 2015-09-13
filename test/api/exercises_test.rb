require_relative '../api_helper'

class ExercisesApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_exercises_requires_key
    get '/exercises'
    assert_equal 401, last_response.status
  end

  def test_exercises
    alice = User.create(username: 'alice', github_id: 1)

    UserExercise.create(user: alice, language: 'go', slug: 'one', archived: true)
    UserExercise.create(user: alice, language: 'go', slug: 'two')
    UserExercise.create(user: alice, language: 'ruby', slug: 'one')
    UserExercise.create(user: alice, language: 'ruby', slug: 'two')

    get '/exercises', {key: alice.key}

    output = last_response.body
    options = {format: :json, :name => 'api_exercises'}
    Approvals.verify(output, options)
  end
end

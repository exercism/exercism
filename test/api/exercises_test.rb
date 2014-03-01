require './test/api_helper'

class ExercisesApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI
  end

  def test_exercises_requires_key
    get '/exercises'
    assert_equal 401, last_response.status
  end

  def test_exercises
    alice = User.create(username: 'alice', github_id: 1)

    UserExercise.create(user: alice, language: 'go', slug: 'one', state: 'done')
    UserExercise.create(user: alice, language: 'go', slug: 'two', state: 'pending')
    UserExercise.create(user: alice, language: 'ruby', slug: 'one', state: 'pending')
    UserExercise.create(user: alice, language: 'ruby', slug: 'two', state: 'pending')

    get '/exercises', {key: alice.key}

    output = last_response.body
    options = {format: :json, :name => 'api_exercises'}
    Approvals.verify(output, options)
  end
end

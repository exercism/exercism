require_relative 'xapi_helper'

class XapiExercisesTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def setup
    super
    Approvals.configure_for_xapi
  end

  def teardown
    super
    Approvals.configure_for_io
  end

  def app
    Xapi::App
  end

  def test_protected_endpoints
    [
      '/v2/exercises/ruby',
      '/v2/exercises',
      '/v2/exercises/restore',
    ].each do |endpoint|
      get endpoint
      assert_equal 401, last_response.status, "GET #{endpoint} should be protected"
    end
  end

  def test_unknown_api_key
      get '/v2/exercises', key: 'no-such-key'
      options = { format: :json, name: 'xapi_unknown_api_key' }
      Approvals.verify(last_response.body, options)
  end

  def test_get_first_exercise_in_track
    user = User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')

    get '/v2/exercises/jewels', key: 'abc123'
    options = { format: :json, name: 'xapi_get_first_exercise_in_track' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_problems_by_language
    user = User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    s1 = Submission.create(
      user: user,
      language: 'fruit',
      slug: 'apple',
      solution: { 'apple.ext' => '// iteration 1' },
      created_at: 10.minutes.ago
    )
    s2 = Submission.create(
      user: user,
      language: 'fruit',
      slug: 'apple',
      solution: { 'apple.ext' => '// iteration 2' },
      created_at: 5.minutes.ago
    )
    UserExercise.create!(
      user: user,
      language: 'fruit',
      slug: 'apple',
      submissions: [s1, s2],
      archived: true,
      iteration_count: 2
    )

    get '/v2/exercises/fruit', key: 'abc123'
    options = { format: :json, name: 'xapi_get_next_exercise_in_track' }
    Approvals.verify(last_response.body, options)
  end

  def test_skip_hello_world_if_already_solved_another_exercise
    user = User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    s = Submission.create(
      user: user,
      language: 'fake',
      slug: 'one',
      solution: { 'one.ext' => '// iteration 1' },
      created_at: 10.minutes.ago
    )
    UserExercise.create!(
      user: user,
      language: 'fake',
      slug: 'one',
      submissions: [s],
      archived: true,
      iteration_count: 2
    )

    get '/v2/exercises/fake', key: 'abc123'

    options = { format: :json, name: 'xapi_get_next_exercise_not_hello_world' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_next_exercise_on_invalid_track
    get '/v2/exercises/invalid_track', key: 'abc123'
    options = { format: :json, name: 'xapi_get_next_exercise_on_invalid_track' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_specific_exercise
    get '/v2/exercises/fruit/apple'

    options = { format: :json, name: 'xapi_get_specific_exercise' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_by_track_slug_invalid_track
    get '/v2/exercises/invalid_track/apple', key: 'abc123'
    options = { format: :json, name: 'xapi_get_specific_exercise_on_invalid_track' }
    Approvals.verify(last_response.body, options)
  end

  def test_get_exercises_by_track_slug_invalid_slug
    get '/v2/exercises/fruit/invalid_slug', key: 'abc123'
    options = { format: :json, name: 'xapi_get_invalid_exercise_on_valid_track' }
    Approvals.verify(last_response.body, options)
  end

  def test_restore_exercises_and_solutions
    user = User.create(github_id: -1, key: 'abc123', username: 'xapi-test-user')
    s1 = Submission.create(
      user: user,
      language: 'fruit',
      slug: 'apple',
      solution: { 'apple.ext' => '// iteration 1' },
      created_at: 10.minutes.ago
    )
    s2 = Submission.create(
      user: user,
      language: 'fruit',
      slug: 'apple',
      solution: { 'apple.ext' => '// iteration 2' },
      created_at: 5.minutes.ago
    )
    UserExercise.create!(
      user: user,
      language: 'fruit',
      slug: 'apple',
      submissions: [s1, s2],
      archived: true,
      iteration_count: 2
    )
    s3 = Submission.create(
      user: user,
      language: 'fruit',
      slug: 'banana',
      solution: { 'apple.ext' => '// iteration 1' },
      created_at: 10.minutes.ago
    )
    UserExercise.create!(
      user: user,
      language: 'fruit',
      slug: 'banana',
      submissions: [s3],
      archived: true,
      iteration_count: 1
    )

    get '/v2/exercises/restore', key: 'abc123'
    options = { format: :json, name: 'xapi_restore_exercises' }
    Approvals.verify(last_response.body, options)
  end
end

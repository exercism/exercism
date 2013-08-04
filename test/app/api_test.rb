require './test/api_helper'

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create(username: 'alice', github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})
  end

  def teardown
    Mongoid.reset
  end

  def test_api_returns_current_assignment_data
    get '/api/v1/user/assignments/current', {key: alice.key}

    output = last_response.body
    options = {format: :json, :name => 'api_current_assignment_data'}
    Approvals.verify(output, options)
  end

  def test_api_complains_if_no_key_is_submitted
    get '/api/v1/user/assignments/current'
    assert_equal 401, last_response.status
  end

  def test_api_complains_if_no_key_is_submitted_for_completed_assignments
    get '/api/v1/user/assignments/completed'
    assert_equal 401, last_response.status
  end

  def test_api_accepts_submission_attempt
    Notify.stub(:everyone, nil) do
      post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'code.rb'}.to_json
    end

    submission = Submission.first
    ex = Exercise.new('ruby', 'word-count')
    assert_equal ex, submission.exercise
    assert_equal 201, last_response.status

    options = {format: :json, :name => 'api_submission_accepted'}
    Approvals.verify(last_response.body, options)
  end

  def test_submit_beyond_end_of_trail
    bob = User.create(github_id: 2, current: {'ruby' => 'word-count'})
    trail = Exercism.current_curriculum.in('ruby')
    bob.complete! trail.exercises.last, on: trail
    get '/api/v1/user/assignments/current', {key: bob.key}
    assert_equal 200, last_response.status
  end

  def test_fetch_demo
    get '/api/v1/assignments/demo'
    assert_equal 200, last_response.status

    options = {format: :json, :name => 'api_demo'}
    Approvals.verify(last_response.body, options)
  end

  def test_completed_sends_back_empty_list_for_new_user
    new_user = User.create(github_id: 2)

    get '/api/v1/user/assignments/completed', {key: new_user.key}

    assert_equal({"assignments" => []}, JSON::parse(last_response.body))
  end

  def test_completed_returns_the_names_of_completed_assignments
    user = User.create(github_id: 2, current: {'ruby' => 'bob'})
    trail = Exercism.current_curriculum.in('ruby')
    exercises = trail.exercises.each
    user.complete! exercises.next, on: trail
    user.complete! exercises.next, on: trail

    get '/api/v1/user/assignments/completed', {key: user.key}

    assert_equal({"assignments" => ['bob', 'rna-transcription']}, JSON::parse(last_response.body))
  end

  def test_peek_returns_assignments_for_all_trails
    user = User.create(github_id: 2, current: {'ruby' => 'bob', 'clojure' => 'rna-transcription'})

    get '/api/v1/user/assignments/next', {key: user.key}

    output = last_response.body
    options = {format: :json, name: 'api_peek_on_two_incomplete_trails'}
    Approvals.verify(output, options)
  end

  def test_peek_behind_complete_trail
    user = User.create(github_id: 2, current: {'ruby' => 'congratulations'})

    get '/api/v1/user/assignments/next', {key: user.key}

    assert_equal 404, last_response.status
    assert_equal "No more assignments!", last_response.body
  end

  def test_peek_returns_assignments_for_incomplete_trails
    user = User.create(github_id: 2, current: {'ruby' => 'congratulations', 'clojure' => 'bob'})

    get '/api/v1/user/assignments/next', {key: user.key}

    assert_equal 200, last_response.status

    output = last_response.body
    options = {format: :json, name: 'api_peek_with_complete_trail'}
    Approvals.verify(output, options)
  end
end

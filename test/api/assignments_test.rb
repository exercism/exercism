require_relative '../api_helper'
require 'mocha/setup'

class AssignmentsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  attr_reader :alice
  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    Language.instance_variable_set(:"@by_track_id", "fake" => "Fake")
  end

  def teardown
    super
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  def test_api_accepts_submission_attempt
    Notify.stub(:everyone, nil) do
      post '/user/assignments', { key: alice.key, solution: { 'fake/one/code.ext' => 'THE CODE' } }.to_json
    end

    submission = Submission.first
    problem = Problem.new('fake', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = { format: :json, name: 'api_submission_accepted' }
    Approvals.verify(last_response.body, options)
  end

  def test_api_accepts_submission_attempt_with_multi_file_solution
    Notify.stub(:everyone, nil) do
      solution = {
        'fake/one/file1.ext' => 'code 1',
        'fake/one/file2.ext' => 'code 2',
      }
      post '/user/assignments', { key: alice.key, solution: solution }.to_json
    end

    submission = Submission.first
    problem = Problem.new('fake', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = { format: :json, name: 'api_multifile_submission_accepted' }
    Approvals.verify(last_response.body, options)
  end

  def test_provides_a_useful_error_message_when_key_is_wrong
    Notify.stub(:everyone, nil) do
      post '/user/assignments', { key: 'no-such-key', solution: { 'fake/one/code.ext' => 'THE CODE' } }.to_json
    end
    assert_equal 401, last_response.status
  end

  def test_api_accepts_submission_on_completed_exercise
    Notify.stub(:everyone, nil) do
      post '/user/assignments', { key: alice.key, language: 'fake', problem: 'one', solution: { 'fake/one/code.ext' => 'THE CODE' } }.to_json
    end

    submission = Submission.first
    problem = Problem.new('fake', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = { format: :json, name: 'api_submission_accepted_on_completed' }
    Approvals.verify(last_response.body, options)
  end

  def test_api_rejects_duplicates
    Attempt.new(alice, Iteration.new({ 'code.ext' => 'THE CODE' }, 'fake', 'one')).save
    Notify.stub(:everyone, nil) do
      post '/user/assignments', { key: alice.key, solution: { 'fake/one/code.ext' => 'THE CODE' } }.to_json
    end

    response_error = JSON.parse(last_response.body)['error']

    assert_equal 400, last_response.status
    assert_equal "duplicate of previous iteration", response_error
  end
end

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
    Exercism.instance_variable_set(:@trails, nil)
    Language.instance_variable_set(:"@by_track_id", {"ruby" => "Ruby"})
  end

  def teardown
    super
    Exercism.instance_variable_set(:@trails, nil)
    Language.instance_variable_set(:"@by_track_id", nil)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_api_accepts_submission_attempt
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, solution: {'ruby/one/code.rb' => 'THE CODE'}}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('ruby', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_submission_accepted'}
    Approvals.verify(last_response.body, options)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_api_accepts_submission_attempt_with_multi_file_solution
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        solution = {
          'ruby/one/file1.rb' => 'code 1',
          'ruby/one/file2.rb' => 'code 2'
        }
        post '/user/assignments', {key: alice.key, solution: solution}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('ruby', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_multifile_submission_accepted'}
    Approvals.verify(last_response.body, options)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def test_provides_a_useful_error_message_when_key_is_wrong
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: 'no-such-key', solution: {'ruby/one/code.rb' => 'THE CODE'}}.to_json
      end
    end
    assert_equal 401, last_response.status
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_api_accepts_submission_on_completed_exercise
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, language: 'ruby', problem: 'one', solution: {'ruby/one/code.rb' => 'THE CODE'}}.to_json
      end
    end

    submission = Submission.first
    problem = Problem.new('ruby', 'one')
    assert_equal problem, submission.problem
    assert_equal 201, last_response.status

    options = {format: :json, name: 'api_submission_accepted_on_completed'}
    Approvals.verify(last_response.body, options)
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  # rubocop:disable Metrics/AbcSize
  def test_api_rejects_duplicates
    Attempt.new(alice, Iteration.new({'code.rb' => 'THE CODE'}, 'ruby', 'one')).save
    Notify.stub(:everyone, nil) do
      Xapi.stub(:exists?, true) do
        post '/user/assignments', {key: alice.key, solution: {'ruby/one/code.rb' => 'THE CODE'}}.to_json
      end
    end

    response_error = JSON.parse(last_response.body)['error']

    assert_equal 400, last_response.status
    assert_equal "duplicate of previous iteration", response_error
  end
  # rubocop:enable Metrics/AbcSize
end

require './test/api_helper'

class SubmissionsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create({
      username: 'alice',
      github_id: 1,
      current: {'ruby' => 'word-count', 'javascript' => 'anagram'}
    })
  end

  def teardown
    Mongoid.reset
  end

  def logged_in
    { github_id: @alice.github_id }
  end

  def not_logged_in
    { github_id: nil }
  end

  def test_get_submission_when_logged_in
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    get "/api/v1/submission/#{Submission.first.id}", {}, 'rack.session' => logged_in
    assert_equal 200, last_response.status
  end

  def test_get_submission_when_not_logged_in
    get '/api/v1/submission/123', {}, 'rack.session' => not_logged_in
    assert_equal 401, last_response.status
  end

  def test_get_submission_when_incorrect_id
    get '/api/v1/submission/123', {}, 'rack.session' => logged_in
    assert_equal 404, last_response.status
  end

end

class SubmissionApiValidResponseTest < Minitest::Test
  include Rack::Test::Methods

  WILDCARD_MATCHER = JsonExpressions::WILDCARD_MATCHER

  def wildcard_matcher
    ::JsonExpressions::WILDCARD_MATCHER
  end

  def app
    ExercismApp
  end

  attr_reader :alice

  def setup
    @alice = User.create({
      username: 'alice',
      github_id: 1,
      current: {'ruby' => 'word-count', 'javascript' => 'anagram'}
    })

  end

  def teardown
    Mongoid.reset
  end

  def logged_in
    {github_id: @alice.github_id}
  end

  def expected_json_pattern
    {
      submission: {
        id: wildcard_matcher,
        is_exercise_completed: false,
        is_submitter: true,
        is_liked: false,
        wants_opinion: false,
        nits: [
          {
            nit:
              {
                id: wildcard_matcher,
                text: /.*<h3>test nit<\/h3>.*/,
                avatar_url: /<img.*gravatar.com.*/,
                github_link: /<a.*github.com.*/,
                timestamp: wildcard_matcher,
                is_nitpicker: true,
              }
          }
        ]
      }
    }
  end

  def test_get_submission_valid_response
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    submission = Submission.first

    Nitpick.new(submission.id, alice, '### test nit').save
    submission.reload
    get "/api/v1/submission/#{submission.id}", {}, 'rack.session' => logged_in

    assert_json_match expected_json_pattern, last_response.body
  end
end

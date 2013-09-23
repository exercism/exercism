require './test/api_helper'

class SubmissionsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def login(user)
    set_cookie("_exercism_login=#{user.github_id}")
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

  def test_get_submission_when_logged_in
    Attempt.new(alice, 'CODE', 'word-count/file.rb').save
    login(alice)
    get "/api/v1/submission/#{Submission.first.id}"
    assert_equal 200, last_response.status
  end

  def test_get_submission_when_not_logged_in
    get '/api/v1/submission/123'
    assert_equal 401, last_response.status
  end

  def test_get_submission_when_incorrect_id
    login(alice)
    get '/api/v1/submission/123'
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

  def login(user)
    set_cookie("_exercism_login=#{user.github_id}")
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
    clear_cookies
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

    CreatesComment.new(submission.id, alice, '### test nit').create
    submission.reload
    login(alice)
    get "/api/v1/submission/#{submission.id}"

    assert_json_match expected_json_pattern, last_response.body
  end
end

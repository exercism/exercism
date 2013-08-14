require './test/api_helper'

class SubmissionApiTest < Minitest::Unit::TestCase
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
    {github_id: @alice.github_id}
  end

  def expected_json_pattern
    {
      submission: {
        id: wildcard_matcher,
        is_exercise_completed: false,
        is_submitter: true,
        is_approvable: true,
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
    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first

    Nitpick.new(submission.id, alice, '### test nit', approvable: true).save
    submission.reload
    get "/api/v1/submission/#{submission.id}", {}, 'rack.session' => logged_in

    assert_json_match expected_json_pattern, last_response.body
  end
end

require_relative '../api_helper'

class SubmissionsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_returns_submission_code
    u = User.create(username: 'alice')
    submission = Submission.create(user: u, code: 'CODE', language: 'ruby')
    get "/submissions/#{submission.key}"
    expected = {"code" => 'CODE', "language" => 'ruby'}
    actual = JSON.parse(last_response.body)
    assert_equal expected, actual
  end
end

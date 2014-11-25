require_relative '../api_helper'

class SubmissionsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_returns_submission_code
    user = User.create(username: 'alice')
    submission = Submission.create(user: user, code: 'CODE', language: 'ruby', slug: 'leap', filename: 'leap.rb')
    response = {
      "problems" => [
        {
          "language" => "Ruby",
          "files" => {"test.rb" => "assert true"}
        }
      ]
    }.to_json
    Xapi.stub(:get, [200, response]) do
      get "/submissions/#{submission.key}"
    end

    Approvals.verify(last_response.body, format: :json, name: 'problem_and_submission')
  end
end

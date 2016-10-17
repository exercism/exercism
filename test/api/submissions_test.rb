require_relative '../api_helper'

class SubmissionsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_returns_submission_code
    user = User.create(username: 'alice')
    submission = Submission.create(user: user, language: 'fake', slug: 'hello-world', solution: { 'hello-world.ext': 'CODE' })
    UserExercise.create(user: user, submissions: [submission], language: 'hello-world', slug: 'hello-world')

    get "/submissions/#{submission.key}"

    Approvals.verify(last_response.body, format: :json, name: 'problem_and_submission')
  end
end

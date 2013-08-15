require './test/api_helper'

class SubmissionApiTest < MiniTest::Unit::TestCase
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
    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
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

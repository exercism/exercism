require './test/api_helper'

class ApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def teardown
    Mongoid.reset
  end

  def test_api_returns_current_assignment_data
    alice = User.create(github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})

    get '/api/v1/user/assignments/current', {key: alice.key}

    output = last_response.body
    options = {format: :json, :name => 'api_current_assignment_data'}
    Approvals.verify(output, options)
  end

  def test_api_complains_if_no_key_is_submitted
    get '/api/v1/user/assignments/current'
    assert_equal 401, last_response.status
  end

end

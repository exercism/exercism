require_relative '../api_helper'

class UsersApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_query_users_is_case_insensitive
    User.create(username: 'Alice', github_id: 1)
    User.create(username: 'mallory', github_id: 2)
    User.create(username: 'bob', github_id: 3)

    post '/user/find', { query: 'al' }

    result = last_response.body
    assert_equal ['Alice', 'mallory'], JSON.parse(result)
  end
end

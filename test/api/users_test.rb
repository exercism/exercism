require_relative '../api_helper'
class UsersApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def test_users_query_sorts_alphabetically
    User.create(github_id: 1, username: 'Aliah')
    User.create(github_id: 3, username: 'Alicia')
    User.create(github_id: 2, username: 'Aisha')

    get '/user/find', query: 'A'

    assert_equal %w(Aisha Aliah Alicia), JSON.parse(last_response.body)
  end

  def test_users_query_is_case_insensitive
    User.create(username: 'Bill', github_id: 1)
    User.create(username: 'bob', github_id: 3)

    get '/user/find', query: 'b'

    assert_equal %w(Bill bob), JSON.parse(last_response.body)
  end

  def test_users_query_sorts_participating_users_higher
    cassidy = User.create!(github_id: 1, username: 'cassidy')
    _ = User.create!(github_id: 2, username: 'christa')
    connie = User.create!(github_id: 3, username: 'connie')

    submission = Submission.create!(user: User.create!)
    Comment.create!(submission: submission, body: 'test', user: cassidy)
    Comment.create!(submission: submission, body: 'test', user: connie)

    get '/user/find', query: 'c', submission_key: submission.key

    assert_equal %w(cassidy connie christa), JSON.parse(last_response.body)
  end

  def test_users_query_matches_based_on_start_of_username
    User.create!(github_id: 1, username: 'aa')
    User.create!(github_id: 1, username: 'ba')

    get '/user/find', query: 'a'

    assert_equal ['aa'], JSON.parse(last_response.body)
  end

  def test_empty_users_query
    User.create!(github_id: 1, username: 'whoever')

    get '/user/find', query: ''

    assert_equal [], JSON.parse(last_response.body)
  end
end

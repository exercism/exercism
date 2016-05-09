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

    get '/user/find', { query: 'A' }

    assert_equal ['Aisha', 'Aliah', 'Alicia'], JSON.parse(last_response.body)
  end

  def test_users_query_is_case_insensitive
    User.create(username: 'Bill', github_id: 1)
    User.create(username: 'bob', github_id: 3)

    get '/user/find', { query: 'b' }

    assert_equal ['Bill', 'bob'], JSON.parse(last_response.body)
  end

  def test_users_query_sorts_participating_users_higher
    cassidy = User.create!(github_id: 1, username: 'cassidy')
    _ = User.create!(github_id: 2, username: 'christa')
    connie  = User.create!(github_id: 3, username: 'connie')

    submission = Submission.create!(user: User.create!)
    Comment.create!(submission: submission, body: 'test', user: cassidy)
    Comment.create!(submission: submission, body: 'test', user: connie)

    get '/user/find', { query: 'c', submission_key: submission.key }

    assert_equal ['cassidy', 'connie', 'christa'], JSON.parse(last_response.body)
  end

  def test_users_query_matches_based_on_start_of_username
    User.create!(github_id: 1, username: 'aa')
    User.create!(github_id: 1, username: 'ba')

    get '/user/find', { query: 'a' }

    assert_equal ['aa'], JSON.parse(last_response.body)
  end

  def test_empty_users_query
    User.create!(github_id: 1, username: 'whoever')

    get '/user/find', { query: '' }

    assert_equal [], JSON.parse(last_response.body)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def test_returns_completion_for_specific_user_by_language
    f= './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(f)]) do
      user = User.create(username: 'alice')
      submission = Submission.create(user: user, language: 'Animal', slug: 'hello-world', solution: {'hello_world.rb' => 'CODE'})
      UserExercise.create(user: user, submissions: [submission], language: 'animal', slug: 'hello-world', iteration_count: 0)
      submission2 = Submission.create(user: user, language: 'Fake', slug: 'apple', solution: {'apple.js' => 'CODE'})
      UserExercise.create(user: user, submissions: [submission2], language: 'fake', slug: 'apple', iteration_count: 1)
      submission3 = Submission.create(user: user, language: 'Animal', slug: 'one', solution: {'one.rb' => 'CODE'})
      UserExercise.create(user: user, submissions: [submission3], language: 'animal', slug: 'one', iteration_count: 1)

      get '/users/alice/statistics'

      response = JSON.parse(last_response.body)
      assert_equal 200, last_response.status
      assert_equal 4, response["statistics"].count
      assert_equal 1, response["statistics"].first["completed"].count
      assert_equal 1, response["statistics"][1]["completed"].count
      count = response["statistics"].count do |language|
        language["completed"].count == 0
      end
      assert_equal 2, count
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def test_returns_error_for_nonexistant_user
    get '/users/alice/statistics'

    response = JSON.parse(last_response.body)
    expected = "unknown user alice"

    assert_equal 404, last_response.status
    assert_equal expected, response["error"]
  end
end

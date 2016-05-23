require_relative '../api_helper'
# rubocop:disable Metrics/ClassLength
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
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  def test_returns_completion_for_specific_user_by_language
    f = './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(f)]) do
      user = User.create(username: 'alice')
      submission = Submission.create(user: user, language: 'Animal', slug: 'hello-world', solution: { 'hello_world.rb' => 'CODE' })
      UserExercise.create(user: user, submissions: [submission], language: 'animal', slug: 'hello-world', iteration_count: 0)
      submission2 = Submission.create(user: user, language: 'Fake', slug: 'apple', solution: { 'apple.js' => 'CODE' })
      UserExercise.create(user: user, submissions: [submission2], language: 'fake', slug: 'apple', iteration_count: 1)
      submission3 = Submission.create(user: user, language: 'Animal', slug: 'one', solution: { 'one.rb' => 'CODE' })
      UserExercise.create(user: user, submissions: [submission3], language: 'animal', slug: 'one', iteration_count: 1)

      get '/users/alice/statistics'

      response = JSON.parse(last_response.body)
      assert_equal 200, last_response.status
      assert_equal 4, response["submission_statistics"].count

      assert_equal submission.language, response["submission_statistics"]["animal"]["language"]
      assert_equal 1, response["submission_statistics"]["animal"]["total"]

      assert_equal [submission3.slug], response["submission_statistics"]["animal"]["completed"]
    end
  end

  def test_returns_complete_comment_statistics_given
    f = './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(f)]) do
      user = User.create(username: 'adam')
      user2 = User.create(username: 'nick')

      submission = Submission.create(user: user, language: 'Animal', slug: 'hello-world', solution: { 'hello_world.rb' => 'CODE' })
      UserExercise.create(user: user, submissions: [submission], language: 'animal', slug: 'hello-world', iteration_count: 0)
      submission2 = Submission.create(user: user2, language: 'Fake', slug: 'apple', solution: { 'apple.js' => 'CODE' })
      UserExercise.create(user: user2, submissions: [submission2], language: 'fake', slug: 'apple', iteration_count: 1)

      user.comments.create(body: "comment one", submission_id: submission.id)
      user.comments.create(body: "comment two", submission_id: submission2.id)
      user2.comments.create(body: "comment three", submission_id: submission.id)
      user2.comments.create(body: "comment four", submission_id: submission2.id)

      get '/users/adam/statistics'

      response = JSON.parse(last_response.body)
      assert_equal 200, last_response.status

      assert_equal 2, response["comment_statistics"]["total_comments_received"]
      assert_equal 1, response["comment_statistics"]["total_comments_received_from_others"]
      assert_equal 2, response["comment_statistics"]["total_comments_created"]
      assert_equal 1, response["comment_statistics"]["total_comments_given_to_others"]
    end
  end

  def test_returns_correct_comment_date_stats
    f = './test/fixtures/xapi_v3_tracks.json'
    X::Xapi.stub(:get, [200, File.read(f)]) do
      user = User.create(username: 'adam')
      user2 = User.create(username: 'nick')

      submission = user.submissions.create

      user.comments.create(body: "comment", submission_id: submission.id, created_at: Time.utc(2000, "jan", 1, 20, 15, 1))
      comment_given = user.comments.create(body: "comment", submission_id: submission.id, created_at: Time.utc(2001, "jan", 1, 20, 15, 1))

      user2.comments.create(body: "comment", submission_id: submission.id, created_at: Time.utc(2002, "jan", 1, 20, 15, 1))
      comment_received = user2.comments.create(body: "comment", submission_id: submission.id, created_at: Time.utc(2003, "jan", 1, 20, 15, 1))

      get '/users/adam/statistics'
      response = JSON.parse(last_response.body)
      assert_equal 200, last_response.status
      assert_equal (Date.today - comment_given.created_at.to_date).to_i, response["comment_statistics"]["days_since_last_comment_given"]
      assert_equal (Date.today - comment_received.created_at.to_date).to_i, response["comment_statistics"]["days_since_last_comment_received"]
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

require_relative '../api_helper'

class IterationsApiTest < Minitest::Test
  include Rack::Test::Methods
  include DBCleaner

  def app
    ExercismAPI::App
  end

  def setup
    super
    @alice = User.create!(username: 'alice', github_id: 1)
  end

  def test_submit_iteration_with_comment
    submission = {
      key: @alice.key,
      solution: { 'code.rb' => 'CODE1' },
      language: 'ruby',
      problem: 'one',
      comment: '',
    }

    Xapi.stub(:exists?, true) do
      post '/user/assignments', submission.to_json
    end

    assert_equal 0, Comment.count

    submission.merge!(comment: 'Awesome code!', solution: { 'code.rb' => 'CODE2' })

    Xapi.stub(:exists?, true) do
      post '/user/assignments', submission.to_json
    end

    assert_equal 1, Comment.count
    comment = Comment.first
    assert_equal submission[:comment], comment.body
  end

  def test_latest_iterations_requires_key
    get '/iterations/latest'
    assert_equal 401, last_response.status
  end

  def test_latest_iterations
    submissions = [{
      user: @alice,
      language: 'go',
      slug: 'one',
      solution: {'oneA.go' => 'CODE1AGO', 'oneB.go' => 'CODE1BGO'},
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'go',
      slug: 'two',
      solution: {'two.go' => 'CODE2GO'},
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'one',
      solution: {'one.rb': 'CODE1RUBY'},
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'two',
      solution: {'two.rb': 'CODE2RUBY'},
    }]

    Submission.create!(submissions)

    submissions.delete_at(1)

    submissions.each do |submission|
      args = [submission[:user].id, submission[:language], submission[:slug]]
      Hack::UpdatesUserExercise.new(*args).update
    end

    Xapi.stub(:exists?, true) do
      get '/iterations/latest', { key: @alice.key }
    end

    output = last_response.body
    options = { format: :json, :name => 'api_iterations' }
    Approvals.verify(output, options)
  end

  def test_skip_problem
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', { key: @alice.key }
    end

    exercise = @alice.exercises.first
    assert_equal 'ruby', exercise.language
    assert_equal 'one', exercise.slug
    refute_equal nil, exercise.skipped_at
    assert_equal 204, last_response.status
  end

  def test_skip_non_existent_problem
    Xapi.stub(:exists?, false) do
      post '/iterations/ruby/not-found/skip', { key: @alice.key }
    end

    expected_message = "Exercise 'not-found' in language 'ruby' doesn't exist. "
    expected_message << "Maybe you mispelled it?"

    assert_equal 404, last_response.status
    assert last_response.body.include?(expected_message)
  end

  def test_skip_problem_as_guest
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', { key: 'invalid-api-key' }
    end

    expected_message = "Please double-check your exercism API key."

    assert_equal 401, last_response.status
    assert last_response.body.include?(expected_message)
  end

  def test_fetch_problem
    Submission.create!(user: @alice, language: 'ruby')

    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/fetch', { key: @alice.key }
    end

    exercise = @alice.exercises.first

    fetched_events_count = @alice.lifecycle_events.where(key: 'fetched').size

    assert_equal 'ruby', exercise.language
    assert_equal 'one', exercise.slug
    assert_in_delta Time.now.utc.to_i, exercise.fetched_at.to_i, 1
    assert_equal 0, exercise.iteration_count
    assert_equal 1, fetched_events_count
    assert_equal 204, last_response.status
  end

  def test_fetch_non_existent_problem
    Xapi.stub(:exists?, false) do
      post '/iterations/ruby/not-found/fetch', { key: @alice.key }
    end

    message = "Exercise 'not-found' in language 'ruby' doesn't exist. " \
              'Maybe you mispelled it?'
    expected_body = { error: message }.to_json

    assert_equal 404, last_response.status
    assert_equal expected_body, last_response.body
  end

  def test_fetch_problem_as_guest
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/fetch', { key: 'invalid-api-key' }
    end

    message = 'Please double-check your exercism API key.'
    expected_body = { error: message }.to_json

    assert_equal 401, last_response.status
    assert_equal expected_body, last_response.body
  end

  def test_fetch_non_existent_problem_as_guest
    Xapi.stub(:exists?, false) do
      post '/iterations/ruby/not-found/fetch', { key: 'invalid-api-key' }
    end

    assert_equal 401, last_response.status
  end

  def test_fetch_problem_when_user_has_exercise
    @alice.exercises.create language: 'ruby', slug: 'one'
    @alice.submissions.create language: 'ruby'

    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/fetch', { key: @alice.key }
    end

    exercise_count = @alice.exercises.count
    exercise = @alice.exercises.first

    assert_equal 1, exercise_count
    assert_equal 204, last_response.status # does not raise PG::UniqueViolation

    assert_in_delta Time.now.utc.to_i, exercise.fetched_at.to_i, 1.0
    assert_equal 0, exercise.iteration_count
  end

  def test_fetch_problem_after_user_has_already_fetched
    a_time_long_ago = Time.utc 2010
    @alice.exercises.create language: 'ruby',
                            slug: 'one',
                            fetched_at: a_time_long_ago
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/fetch', { key: @alice.key }
    end

    exercise = @alice.exercises.first
    assert_equal a_time_long_ago, exercise.fetched_at
  end

  def test_fetch_problem_when_user_has_iterations
    @alice.exercises.create language: 'ruby', slug: 'one', iteration_count: 3
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/fetch', { key: @alice.key }
    end

    exercise = @alice.exercises.first
    assert_equal 3, exercise.iteration_count
  end
end

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
      state: 'superseded',
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'go',
      slug: 'two',
      solution: {'two.go' => 'CODE2GO'},
      state: 'superseded',
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'one',
      state: 'pending',
      solution: {'one.rb': 'CODE1RUBY'},
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'two',
      state: 'hibernating',
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
    assert_equal 'unstarted', exercise.state
    assert_equal 204, last_response.status
  end

  def test_skip_skipped_problem
    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', { key: @alice.key }
      post '/iterations/ruby/one/skip', { key: @alice.key }
    end

    assert_equal 400, last_response.status
    assert last_response.body.include?('already been skipped')
  end

  def test_skip_started_problem
    submission = Submission.create!(
      user: @alice,
      language: 'ruby',
      slug: 'one',
      code: 'CODE1RB',
      state: 'pending',
      filename: 'one.rb'
    )

    args = [submission.user.id, submission.language, submission.slug]
    Hack::UpdatesUserExercise.new(*args).update

    Xapi.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', { key: @alice.key }
    end

    assert_equal 400, last_response.status
    assert last_response.body.include?('already been started')
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
end

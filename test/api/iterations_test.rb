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

    X::Exercise.stub(:exists?, true) do
      post '/user/assignments', submission.to_json
    end

    assert_equal 0, Comment.count

    submission[:comment] = 'Awesome code!'
    submission[:solution] = { 'code.rb' => 'CODE2' }

    X::Exercise.stub(:exists?, true) do
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
      solution: { 'oneA.go' => 'CODE1AGO', 'oneB.go' => 'CODE1BGO' },
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'go',
      slug: 'two',
      solution: { 'two.go' => 'CODE2GO' },
      created_at: 10.minutes.ago,
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'one',
      solution: { 'one.rb': 'CODE1RUBY' },
    }, {
      user: @alice,
      language: 'ruby',
      slug: 'two',
      solution: { 'two.rb': 'CODE2RUBY' },
    }]

    Submission.create!(submissions)

    submissions.delete_at(1)

    submissions.each do |submission|
      args = [submission[:user].id, submission[:language], submission[:slug]]
      Hack::UpdatesUserExercise.new(*args).update
    end

    X::Exercise.stub(:exists?, true) do
      get '/iterations/latest', key: @alice.key
    end

    output = last_response.body
    options = { format: :json, name: 'api_iterations' }
    Approvals.verify(output, options)
  end

  def test_skip_problem
    X::Exercise.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', key: @alice.key
    end

    exercise = @alice.exercises.first
    assert_equal 'ruby', exercise.language
    assert_equal 'one', exercise.slug
    refute_equal nil, exercise.skipped_at
    assert_equal 204, last_response.status
  end

  def test_skip_non_existent_problem
    X::Exercise.stub(:exists?, false) do
      post '/iterations/ruby/not-found/skip', key: @alice.key
    end

    expected_message = "Exercise 'not-found' in language 'ruby' doesn't exist. "
    expected_message << "Maybe you mispelled it?"

    assert_equal 404, last_response.status
    assert last_response.body.include?(expected_message)
  end

  def test_skip_problem_as_guest
    X::Exercise.stub(:exists?, true) do
      post '/iterations/ruby/one/skip', key: 'invalid-api-key'
    end

    expected_message = "Please double-check your exercism API key."

    assert_equal 401, last_response.status
    assert last_response.body.include?(expected_message)
  end

  def test_submit_problem_with_old_client
    submission = {
      "key" => @alice.key,
      "path" => "/go/binary/binary.go",
      "code" => "Hello, World!",
      "dir" => "/path/to/exercism/dir",
    }

    X::Exercise.stub(:exists?, true) do
      post '/user/assignments', submission.to_json
    end

    submission = Submission.first
    assert_equal "go", submission.track_id
    assert_equal "binary", submission.slug
    expected = { "binary.go" => "Hello, World!" }
    assert_equal expected, submission.solution
  end

  def test_submit_problem_with_mixed_case_track_and_no_language
    submission = {
      "key" => @alice.key,
      "path" => "/Go/binary/binary.go",
      "code" => "Hello, World!",
      "dir" => "/path/to/exercism/dir",
    }

    X::Exercise.stub(:exists?, true) do
      post '/user/assignments', submission.to_json
    end

    submission = Submission.first
    assert_equal "binary", submission.slug
    expected = { "binary.go" => "Hello, World!" }
    assert_equal expected, submission.solution
    assert_equal "go", submission.track_id
  end
end

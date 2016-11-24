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
      solution: { 'code.ext' => 'CODE1' },
      language: 'fake',
      problem: 'one',
      comment: '',
    }

    post '/user/assignments', submission.to_json

    assert_equal 0, Comment.count

    submission[:comment] = 'Awesome code!'
    submission[:solution] = { 'code.ext' => 'CODE2' }

    post '/user/assignments', submission.to_json

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

    get '/iterations/latest', key: @alice.key

    output = last_response.body
    options = { format: :json, name: 'api_iterations' }
    Approvals.verify(output, options)
  end

  def test_skip_problem
    post "/iterations/animal/dog/skip", key: @alice.key
    exercise = @alice.exercises.first
    assert_equal 'animal', exercise.language
    assert_equal 'dog', exercise.slug
    refute_equal nil, exercise.skipped_at
    assert_equal 204, last_response.status
  end

  def test_skip_non_existent_problem
    post '/iterations/animal/not-found/skip', key: @alice.key

    assert_equal 400, last_response.status
    assert_match /Unknown\ problem/, last_response.body
  end

  def test_skip_problem_as_guest
    post '/iterations/ruby/one/skip', key: 'invalid-api-key'

    expected_message = "Please double-check your exercism API key."

    assert_equal 401, last_response.status
    assert last_response.body.include?(expected_message)
  end

  def test_submit_problem_with_old_client
    data = {
      "key" => @alice.key,
      "path" => "/fake/one/one.ext",
      "code" => "Hello, World!",
      "dir" => "/path/to/exercism/dir",
    }

    post '/user/assignments', data.to_json
    assert_equal 201, last_response.status, last_response.body

    submission = Submission.first
    assert_equal "fake", submission.language
    assert_equal "one", submission.slug
    expected = { "one.ext" => "Hello, World!" }
    assert_equal expected, submission.solution
  end

  def test_submit_problem_with_mixed_case_track_and_no_language
    submission = {
      "key" => @alice.key,
      "path" => "/Fake/one/one.ext",
      "code" => "Hello, World!",
      "dir" => "/path/to/exercism/dir",
    }

    post '/user/assignments', submission.to_json

    submission = Submission.first
    assert_equal "one", submission.slug
    expected = { "one.ext" => "Hello, World!" }
    assert_equal expected, submission.solution
    assert_equal "fake", submission.language
  end
end

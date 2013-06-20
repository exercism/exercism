require './test/api_helper'

class ApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create(github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})
  end

  def teardown
    Mongoid.reset
  end

  def test_api_returns_current_assignment_data
    get '/api/v1/user/assignments/current', {key: alice.key}

    output = last_response.body
    options = {format: :json, :name => 'api_current_assignment_data'}
    Approvals.verify(output, options)
  end

  def test_api_complains_if_no_key_is_submitted
    get '/api/v1/user/assignments/current'
    assert_equal 401, last_response.status
  end

  def test_api_accepts_submission_attempt
    post '/api/v1/user/assignments', {key: alice.key, code: 'THE CODE', path: 'code.rb'}.to_json

    submission = Submission.first
    ex = Exercise.new('ruby', 'word-count')
    assert_equal ex, submission.exercise
  end

  def test_submit_beyond_end_of_trail
    bob = User.create(github_id: 2, current: {'ruby' => 'word-count'})
    trail = Exercism.current_curriculum.in('ruby')
    bob.complete! trail.exercises.last, on: trail
    get '/api/v1/user/assignments/current', {key: bob.key}
    assert_equal 200, last_response.status
  end

  def test_submit_comment_on_nit
    bob = User.create(github_id: 2)

    Attempt.new(alice, 'CODE', 'path/to/file.rb').save
    submission = Submission.first
    nit = Nit.new(user: bob, comment: "ok")
    submission.nits << nit
    submission.save

    url = "/submissions/#{submission.id}/nits/#{nit.id}/argue"
    post url, {comment: "idk"}, {'rack.session' => {github_id: 2}}

    nit = submission.reload.nits.find_by(id: nit.id)
    text = nit.comments.first.body
    assert_equal 'idk', text
  end

end

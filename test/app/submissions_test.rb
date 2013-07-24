require './test/api_helper'

class ApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create(username: 'alice', github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})
  end

  def teardown
    Mongoid.reset
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


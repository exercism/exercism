require_relative '../app_helper'
require 'mocha/setup'

class CommentThreadsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  attr_reader :bob, :comment
  def setup
    super
    @bob = User.create(
      username: 'bob',
      github_id: 1,
      email: 'bob@example.com'
    )
    sub1     = Submission.create(user: bob, language: 'ruby', slug: 'one')
    @comment = Comment.create(user: bob, submission: sub1, body: 'something')
  end

  def app
    ExercismWeb::App
  end

  def create_comment_threads_path
    "/comments/#{comment.id}/comment_threads"
  end

  def test_user_must_be_logged_in
    post create_comment_threads_path
    assert_equal 302, last_response.status
    location = "http://example.org/please-login?return_path=#{create_comment_threads_path}"
    assert_equal location, last_response.location, "Wrong redirect for POST #{create_comment_threads_path}"
  end

  def test_create_comment_threads
    post create_comment_threads_path, {body: 'this is a review'}, login(bob)

    assert_equal 200, last_response.status

    comment_thread = CommentThread.first
    assert_equal "this is a review", comment_thread.body
  end

  def test_return_with_422_when_body_is_empty
    post create_comment_threads_path, {body: ''}.to_json, login(bob)

    assert_equal 422, last_response.status
    assert_equal({body: ["can't be blank"]}.to_json, last_response.body)
  end
end

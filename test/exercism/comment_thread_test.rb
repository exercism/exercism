require_relative '../integration_helper'
require 'minitest/pride'

class CommentThreadTest < Minitest::Test
  include DBCleaner

  attr_reader :user, :comment, :body, :comment_thread
  def setup
    super
    @user           = User.create(username: 'alice')
    sub1            = Submission.create(user: user, language: 'python', slug: 'one')
    @comment        = Comment.create(user: user, submission: sub1, body: 'something')
    @body           = "Nice review"
    @comment_thread = CommentThread.create(
      comment: comment,
      body: body,
      user: user
    )
  end

  def test_not_create_comment_thread_with_out_body
    ct = CommentThread.new(
      user: user,
      comment: comment
    )

    refute ct.save
    assert_equal ct.errors[:body], ["can't be blank"]
  end

  def test_not_create_comment_thread_with_out_comment
    ct = CommentThread.new(
      user: user,
      body: body
    )

    refute ct.save
    assert_equal ct.errors[:comment_id], ["can't be blank"]
  end

  def test_not_create_comment_thread_with_out_user
    ct = CommentThread.new(
      comment: comment,
      body: body
    )

    refute ct.save
    assert_equal ct.errors[:user_id], ["can't be blank"]
  end

  def test_comment_thread_responds_to_user_method
    assert comment_thread.respond_to?(:user)
  end

  def test_comment_thread_responds_to_comment_method
    assert comment_thread.respond_to?(:comment)
  end

  def test_html_body_is_set_before_create
    assert_equal comment_thread.html_body, "<p>Nice review</p>\n"
  end
end

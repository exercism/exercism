require_relative '../approval_helper'

require 'services/message'
require 'services/comment_message'
require 'exercism/problem'

class CommentMessageTest < Minitest::Test

  FakeUser = Struct.new(:username, :email)
  FakeSubmission = Struct.new(:key, :user, :problem)
  FakeComment = Struct.new(:body, :submission)

  attr_reader :alice, :submission, :comment

  def setup
    @alice = FakeUser.new('alice', 'alice@example.com')
    @submission = FakeSubmission.new(
      'KEY',
      FakeUser.new('bob', 'bob@example.com'),
      Problem.new('ruby', 'word-count'),
    )
    @comment = FakeComment.new('This is awesome!!!', @submission)
  end

  def dispatch
    @dispatch ||= CommentMessage.new(
      instigator: alice,
      target: comment,
      site_root: "example.com",
    )
  end

  def test_subject
    assert_equal "Your Word Count exercise in Ruby got a new comment", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'nitpick_email_body')
  end

end

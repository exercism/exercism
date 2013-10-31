require './test/approval_helper'

require 'services/message'
require 'services/comment_message'
require 'exercism/exercise'

class CommentMessageTest < Minitest::Test

  FakeUser = Struct.new(:username, :email)
  FakeSubmission = Struct.new(:key, :user, :exercise)
  FakeComment = Struct.new(:body, :submission)

  attr_reader :alice, :submission, :comment

  def setup
    @alice = FakeUser.new('alice', 'alice@example.com')
    @submission = FakeSubmission.new(
      'KEY',
      FakeUser.new('bob', 'bob@example.com'),
      Exercise.new('ruby', 'word-count'),
    )
    @comment = FakeComment.new('This is awesome!!!', @submission)
  end

  def dispatch
    @dispatch ||= CommentMessage.new(
      instigator: alice,
      target: comment,
      site_root: "http://example.com",
    )
  end

  def test_subject
    assert_equal "New comment from alice", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'nitpick_email_body')
  end

end

require './test/approval_helper'

require 'services/message'
require 'services/comment_message'
require 'exercism/exercise'

class CommentMessageTest < Minitest::Test

  FakeUser = Struct.new(:username, :email)
  FakeSubmission = Struct.new(:id, :user, :exercise)

  attr_reader :alice, :submission

  def setup
    super
    @alice = FakeUser.new('alice', 'alice@example.com')

    @submission = FakeSubmission.new(
      'ID',
      FakeUser.new('bob', 'bob@example.com'),
      Exercise.new('ruby', 'word-count')
    )
  end

  def dispatch
    @dispatch ||= CommentMessage.new(
      instigator: alice,
      submission: submission,
      site_root: "http://example.com"
    )
  end

  def test_subject
    assert_equal "New comment from alice", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'nitpick_email_body')
  end

end

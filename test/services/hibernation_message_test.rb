require_relative '../approval_helper'
require 'services/message'
require 'services/hibernation_message'
require 'exercism/problem'

class HibernationMessageTest < Minitest::Test
  FakeUser = Struct.new(:username, :email, :id)
  FakeComment = Struct.new(:user)
  FakeSubmission = Struct.new(:user, :comments, :key, :problem)

  attr_reader :alice, :bob

  def setup
    @alice = FakeUser.new('alice', 'alice@example.com', 1)
    @bob = FakeUser.new('bob', 'bob@example.com', 2)
  end

  def problem
    Problem.new('ruby', 'word-count')
  end

  def message_about(submission)
    HibernationMessage.new(
      instigator: alice,
      target: submission,
      site_root: "http://example.com"
    )
  end

  def test_subject
    submission = FakeSubmission.new(bob, [], 'abc', problem)
    assert_equal "Your Word Count exercise in Ruby went into hibernation", message_about(submission).subject
  end

  def test_body
    comments = [FakeComment.new(bob), FakeComment.new(alice)]
    submission = FakeSubmission.new(bob, comments, 'abc', problem)
    Approvals.verify(message_about(submission).body, name: 'hibernation_email_body')
  end

  def test_body_when_user_commented_last
    comments = [FakeComment.new(alice), FakeComment.new(bob)]
    submission = FakeSubmission.new(bob, comments, 'abc', problem)
    Approvals.verify(message_about(submission).body, name: 'hibernation_email_body_user_commented_last')
  end
end


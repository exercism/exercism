require './test/approval_helper'

require 'services/message'
require 'services/approval_message'
require 'exercism/exercise'


class ApprovalMessageTest < Minitest::Test

  FakeUser = Struct.new(:username, :email)
  FakeSubmission = Struct.new(:id, :user, :exercise)

  attr_reader :alice, :submission

  def setup
    @alice = FakeUser.new('alice', 'alice@example.com')

    @submission = FakeSubmission.new(
      'ID',
      FakeUser.new('bob', 'bob@example.com'),
      Exercise.new('ruby', 'word-count')
    )
  end

  def dispatch
    @dispatch ||= ApprovalMessage.new(
      instigator: alice,
      submission: submission,
      site_root: "http://example.com"
    )
  end

  def test_subject
    assert_equal "Word Count in ruby was approved by alice", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'approval_email_body')
  end

end

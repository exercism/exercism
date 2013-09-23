require './test/approval_helper'

require 'services/message'
require 'services/hibernation_message'
require 'exercism/exercise'


class HibernationMessageTest < Minitest::Test

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
    @dispatch ||= HibernationMessage.new(
      instigator: alice,
      submission: submission,
      site_root: "http://example.com"
    )
  end

  def test_subject
    assert_equal "Your ruby word-count submission went into hibernation", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'hibernation_email_body')
  end

end

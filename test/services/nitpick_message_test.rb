require './test/approval_helper'

require 'services/message'
require 'services/nitpick_message'
require 'exercism/exercise'

class NitpickMessageTest < MiniTest::Unit::TestCase

  attr_reader :alice, :submission
  # Oh, gawd. Can we have simpler stubs?
  def setup
    @alice = Object.new
    def @alice.username
      'alice'
    end

    @submission = Object.new
    def @submission.user
      bob = Object.new
      def bob.username
        'bob'
      end
      def bob.email
        'bob@example.com'
      end
      bob
    end

    def @submission.exercise
      Exercise.new('ruby', 'word-count')
    end

    def @submission.id
      'SUBMISSION_ID'
    end
  end

  def dispatch
    @dispatch ||= NitpickMessage.new(
      instigator: alice,
      submission: submission,
      site_root: "http://example.com"
    )
  end

  def test_subject
    assert_equal "New nitpick from alice", dispatch.subject
  end

  def test_body
    Approvals.verify(dispatch.body, name: 'nitpick_email_body')
  end

end

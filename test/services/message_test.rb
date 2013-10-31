require_relative "../test_helper"
require 'services'

class MessageTest < Minitest::Test
  class FakeMessage < Message
    def subject
      "Fake message to #{recipient.username} from #{from}"
    end

    # override the ERB stuff.
    # We can test that directly on
    # each email without involving smtp
    def body
      "A clever man commits no minor blunders."
    end
  end

  FakeUser = Struct.new(:username, :email)
  FakeSubmission = Struct.new(:user)

  def test_send_nitpick_email
    instigator = FakeUser.new('instigator', 'instigator@example.com')
    submitter = FakeUser.new('submitter', 'submitter@example.com')
    submission = FakeSubmission.new(submitter)
    dispatch = FakeMessage.new(
      instigator: instigator,
      target: submission,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    ).ship
    # Integration test. Go look in mailcatcher to make sure you're happy with this
  end
end

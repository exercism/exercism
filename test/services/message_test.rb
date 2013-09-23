require_relative "../integration_helper"

require 'services'

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

class MessageTest < Minitest::Test
  attr_reader :submission, :locksmith
  def setup
    exercise = Exercise.new('fake', 'one')
    @submission = Submission.on(exercise)
    @submission.user = User.create(
      github_id: 1,
      email: "bobguy1998@example.com",
      username: "AwesomeBob",
    )
    @submission.save

    @locksmith = User.create(
      github_id: 1337,
      email: "locksmith@example.com",
      username: "locksmith",
    )
  end

  def test_send_nitpick_email
    dispatch = FakeMessage.new(
      instigator: locksmith,
      submission: submission,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    ).ship
    # Integration test. Go look in mailcatcher to make sure you're happy with this
  end
end

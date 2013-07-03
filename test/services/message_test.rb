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

class MessageTest < MiniTest::Unit::TestCase
  attr_reader :submission, :admin
  def setup
    exercise = Exercise.new('nong', 'one')
    @submission = Submission.on(exercise)
    @submission.user = User.create(
      github_id: 1,
      email: "bobguy1998@example.com",
      username: "AwesomeBob",
    )
    @submission.save

    @admin = User.create(
      github_id: 1337,
      email: "admin@example.com",
      username: "kytrinyx",
    )
  end

  def teardown
    Mongoid.reset
  end

  def test_send_nitpick_email
    dispatch = FakeMessage.new(
      instigator: admin,
      submission: submission,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    ).ship
    # Integration test. Go look in mailcatcher to make sure you're happy with this
  end
end

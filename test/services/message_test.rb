require_relative "../integration_helper"

require 'services'

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
    nitpick = Nitpick.new(@submission.id, admin, "Needs more monads").save
    dispatch = NitpickMessage.new(
      instigator: nitpick.nitpicker,
      submission: nitpick.submission,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    ).ship
    # Integration test. Go look in mailcatcher to make sure you're happy with this
  end
end

require_relative "../integration_helper"
require 'pry'

require 'services/email'
require 'services/dispatch'

class DispatchTest < MiniTest::Unit::TestCase
  def setup
    exercise = Exercise.new('nong', 'one')
    @submission = Submission.on(exercise)
    @submission.user = User.create(
      github_id: 84274928,
      email: "bobguy1998@example.com",
      username: "AwesomeBob",
    )
    @submission.save
    current_user = User.create(
      github_id: 1337,
      email: "self@alice.com",
      username: "l@@kinggl@ss",
    )
    @nitpick = Nitpick.new(@submission.id, current_user, "Needs more monads")
    @nitpick.save
  end

  def teardown
    Mongoid.reset
  end

  def test_send_email_upon_nitpick
    user = @submission.user
    dispatch = Dispatch.new_nitpick(
      submitter: user,
      nitpick: @nitpick,
      intercept_emails: true
    )
    assert_equal dispatch.name, user.username
  end
end

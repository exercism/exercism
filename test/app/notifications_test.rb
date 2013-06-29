require_relative "../integration_helper"
require 'pry'

class Email
  def self.ship(*args);end
end

class NotificationsTest < MiniTest::Unit::TestCase

  def teardown
    Mongoid.reset
  end

  def test_send_email_upon_nitpick
    exercise = Exercise.new('nong', 'one')
    submission = Submission.on(exercise)
    submission.user = User.create(
      github_id: 84274928,
      email: "bobguy1998@aol.com",
      username: "AwesomeBob",
    )
    submission.save
    current_user = User.create(
      github_id: 1337,
      email: "self@alice.com",
      username: "l@@kinggl@ss",
    )
    nitpick = Nitpick.new(submission.id, current_user, "Needs more monads")
    nitpick.save
    Email.expects(:ship).with({
      to: submission.user.email,
      name: submission.user.username,
      subject: "New Nitpick From #{current_user.username}",
    })
    Notifications.new_nitpick({ submitter: submission.user, nitpick: nitpick })
  end
end

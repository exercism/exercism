require_relative "../../integration_helper"
require 'pry'

class DispatchTest < MiniTest::Unit::TestCase

  def teardown
    Mongoid.reset
  end

  def test_send_email_upon_nitpick
    exercise = Exercise.new('nong', 'one')
    submission = Submission.on(exercise)
    submission.user = User.create(
      github_id: 84274928,
      email: "bobguy1998@example.com",
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
    Email.any_instance.expects(:ship)
    Dispatch.new_nitpick({ submitter: submission.user, nitpick: nitpick })
  end
end

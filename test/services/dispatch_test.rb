require_relative "../integration_helper"

require 'services'

class DispatchTest < MiniTest::Unit::TestCase
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

  def test_send_email_upon_nitpick
    nitpick = Nitpick.new(@submission.id, admin, "Needs more monads").save
    dispatch = Dispatch.new_nitpick(
      nitpick: nitpick,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    )
    assert_equal dispatch.name, submission.user.username
    url = "http://test.exercism.io/user/submissions/#{submission.id}"
    assert_equal url, dispatch.submission_url
    assert /nitpick/ =~ dispatch.subject, "Expected subject to match /nitpick/"
  end
end

require_relative "../integration_helper"

require 'services'

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
    @nitpick = Nitpick.new(@submission.id, current_user, "Needs more monads").save
  end

  def teardown
    Mongoid.reset
  end

  def test_send_email_upon_nitpick
    dispatch = Dispatch.new_nitpick(
      nitpick: @nitpick,
      intercept_emails: true,
      site_root: 'http://test.exercism.io'
    )
    user = @submission.user
    assert_equal dispatch.name, user.username
    url = "http://test.exercism.io/user/submissions/#{@submission.id}"
    assert_equal url, dispatch.submission_url
    assert /Nitpick/ =~ dispatch.subject, "Expected subject to match /Nitpick/"
  end
end

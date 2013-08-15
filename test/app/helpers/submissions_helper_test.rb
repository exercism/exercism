require './test/test_helper'
require 'app/helpers/submissions_helper'

class SubmissionsHelperTest < Minitest::Test

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::SubmissionsHelper)
    @helper
  end

  def setup
    @alice      = User.new(username: 'alice', email: 'alice@example.com')
    @fred       = User.new(username: 'fred', email: 'fred@example.com')
    @submission = Submission.new(user: @alice)
  end

  def test_user_can_mute_other_submissions
    assert_equal true, helper.can_mute?(@submission, @fred)
  end

  def test_user_cannot_mute_own_submission
    assert_equal false, helper.can_mute?(@submission, @alice)
  end

  def test_user_can_mute_an_unmuted_submission
    assert_equal "/submissions/#{@submission.id}/mute", helper.mute_button_action_for(@submission, @fred)
  end

  def test_user_can_unmute_a_muted_submission
    @submission.muted_by = [@fred.username]
    assert_equal "/submissions/#{@submission.id}/unmute", helper.mute_button_action_for(@submission, @fred)
  end

end

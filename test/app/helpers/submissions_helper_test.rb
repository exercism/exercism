require './test/integration_helper'
require 'app/helpers/submissions_helper'

class SubmissionsHelperTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @alice      = User.new(username: 'alice', email: 'alice@example.com')
    @fred       = User.new(username: 'fred', email: 'fred@example.com')
    @submission = Submission.create(user: @alice)
  end

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(Sinatra::SubmissionsHelper)
    @helper
  end

  def test_no_views
    assert_equal "0 views", helper.view_count_for(@submission)
  end

  def test_1_view
    @submission.viewed!(@fred)
    assert_equal "1 view", helper.view_count_for(@submission)
  end

  def test_many_views
    @submission.viewed!(@fred)
    @submission.viewed!(@alice)
    assert_equal "2 views", helper.view_count_for(@submission)
  end

  def test_user_can_mute_other_submissions
    assert_equal true, helper.can_mute?(@submission, @fred)
  end

  def test_user_cannot_mute_own_submission
    assert_equal false, helper.can_mute?(@submission, @alice)
  end

  def test_user_can_mute_an_unmuted_submission
    assert_equal "/submissions/#{@submission.key}/mute", helper.mute_button_action_for(@submission, @fred)
  end

  def test_user_can_unmute_a_muted_submission
    @submission.muted_by << @fred
    assert_equal "/submissions/#{@submission.key}/unmute", helper.mute_button_action_for(@submission, @fred)
  end

  def test_no_likes
    assert_equal '', helper.these_people_like_it([])
  end

  def test_one_like
    assert_equal '@alice thinks this looks great', helper.these_people_like_it([User.new(username: 'alice')])
  end

  def test_two_likes
    users = [
      User.new(username: 'alice'),
      User.new(username: 'bob')
    ]
    assert_equal '@alice and @bob think this looks great', helper.these_people_like_it(users)
  end

  def test_many_likes
    users = [
      User.new(username: 'alice'),
      User.new(username: 'bob'),
      User.new(username: 'charlie')
    ]
    assert_equal '@alice, @bob, and @charlie think this looks great', helper.these_people_like_it(users)
  end

  def test_like_submission_button_for_non_nitpicker
    refute helper.like_submission_button(@submission, @fred)
  end

  def test_like_submission_button_for_owner
    refute helper.like_submission_button(@submission, @alice)
  end

  def test_like_submission_button_for_nitpicker
    @fred.mastery << 'ruby'
    @submission.exercise.language = 'ruby'
    expected = %Q{
      <form accept-charset="UTF-8" action="/submissions/#{@submission.key}/like" method="POST" class="pull-left" style="display: inline;">
        <button type="submit" name="like" class="btn">Looks great!</button>
      </form>
    }.strip.squeeze(" ")
    actual = helper.like_submission_button(@submission, @fred).strip.squeeze(" ")
    assert_equal expected, actual
  end

  def test_like_submission_button_for_nitpicker_who_has_liked
    @fred.mastery << 'ruby'
    @submission.exercise.language = 'ruby'
    @submission.liked_by << @fred
    expected = %Q{
      <form accept-charset="UTF-8" action="/submissions/#{@submission.key}/unlike" method="POST" class="pull-left" style="display: inline;">
        <button type="submit" name="unlike" class="btn">I didn't mean to like this!</button>
      </form>
    }.strip.squeeze(" ")
    actual = helper.like_submission_button(@submission, @fred).strip.squeeze(" ")
    assert_equal expected, actual
  end

end

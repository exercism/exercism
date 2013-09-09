require './test/mongo_helper'
require 'app/helpers/submissions_helper'
require 'exercism/locksmith'
require 'exercism/problem_set'
require 'exercism/user'
require 'exercism/submission'

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

  def test_no_views
    @submission.save
    assert_equal "0 views", helper.view_count_for(@submission)
  end

  def test_1_view
    @submission.save
    @submission.viewed!(@fred)
    assert_equal "1 view", helper.view_count_for(@submission)
  end

  def test_many_views
    @submission.save
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
    assert_equal "/submissions/#{@submission.id}/mute", helper.mute_button_action_for(@submission, @fred)
  end

  def test_user_can_unmute_a_muted_submission
    @submission.muted_by = [@fred.username]
    assert_equal "/submissions/#{@submission.id}/unmute", helper.mute_button_action_for(@submission, @fred)
  end

  def test_no_likes
    assert_equal '', helper.these_people_like_it([])
  end

  def test_one_like
    assert_equal '@alice thinks this looks great', helper.these_people_like_it(['alice'])
  end

  def test_two_likes
    assert_equal '@alice and @bob think this looks great', helper.these_people_like_it(['alice', 'bob'])
  end

  def test_many_likes
    assert_equal '@alice, @bob, and @charlie think this looks great', helper.these_people_like_it(['alice', 'bob', 'charlie'])
  end
end

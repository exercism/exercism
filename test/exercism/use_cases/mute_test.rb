require './test/integration_helper'
require 'services/message'
require 'services/hibernation_message'

class MuteTest < Minitest::Test

  def teardown
    super
    @alice = nil
    @bob = nil
    @submission = nil
  end

  def a_week
    60 * 60 * 24 * 7
  end

  def alice
    @alice ||= User.create(username: 'alice', mastery: ['ruby'])
  end

  def bob
    @bob ||= User.create(username: 'bob')
  end

  def submission
    @submission ||= Submission.create(user: bob, language: 'ruby', slug: 'bob', created_at: Time.now - (a_week*2))
  end

  def test_mute_pending_submission
    refute submission.muted_by?(alice), "Unexpectedly muted"
    Mute.new(submission, alice).save
    submission.reload
    assert submission.muted_by?(alice), "Should be muted"
  end

  def test_do_not_mute_superseded_submission
    submission.state = 'superseded'
    Mute.new(submission, alice).save
    submission.reload
    refute submission.muted_by?(alice), "Unexpectedly muted"
  end

  def test_trigger_hibernation
    submission.comments << Comment.new(user: alice, created_at: Time.now - a_week)
    submission.reload
    Message.stub(:ship, nil) do
      Mute.new(submission, alice).save
    end
    assert_equal 'hibernating', submission.state
    note = submission.user.notifications.first
    assert note.hibernating?
  end

  def test_do_not_hibernate_if_no_nits
    Mute.new(submission, alice).save
    submission.reload
    refute_equal 'hibernating', submission.state
  end

  def test_do_not_hibernate_if_submitter_commented_last
    submission.comments << Comment.new(user: bob, created_at: Time.now - a_week)
    Mute.new(submission, alice).save
    submission.reload
    refute_equal 'hibernating', submission.state
  end

  def test_do_not_hibernate_if_last_activity_was_recent
    submission.comments << Comment.new(user: alice, created_at: Time.now - (a_week-1))
    Mute.new(submission, alice).save
    submission.reload
    refute_equal 'hibernating', submission.state
  end

  def test_do_not_hibernate_if_muter_is_not_locksmith
    charlie = User.new(username: 'charlie')
    submission.comments << Comment.new(user: alice, created_at: Time.now - a_week)
    Mute.new(submission, charlie).save
    submission.reload
    assert submission.pending?
  end
end

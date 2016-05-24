require_relative '../integration_helper'

class NotificationTest < Minitest::Test
  include DBCleaner

  attr_reader :alice, :bob, :submission, :exercise
  def setup
    super
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob')
    @submission = Submission.create(language: 'ruby', slug: 'one', user: alice)
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update
    @exercise = @submission.reload.user_exercise
  end

  def test_create_notification_on_submission
    assert_equal 0, Notification.count
    Notification.on(submission, user_id: bob.id, action: 'comment', actor_id: alice.id)
    assert_equal 1, Notification.count

    n = Notification.first

    assert_equal submission, n.iteration
    assert_equal bob.id, n.user_id
    assert_equal 'comment', n.action
  end

  def test_dont_create_new_notification_if_old_is_unread
    Notification.on(submission, user_id: bob.id, action: 'comment', actor_id: alice.id)
    Notification.on(submission, user_id: bob.id, action: 'comment', actor_id: alice.id)

    assert_equal 1, Notification.count
  end

  def test_create_new_notification_if_old_one_is_read
    Notification.on(submission, user_id: bob.id, action: 'comment', actor_id: alice.id)
    assert_equal 1, Notification.count

    Notification.viewed!(submission, bob)

    Notification.on(submission, user_id: bob.id, action: 'comment', actor_id: alice.id)
    assert_equal 2, Notification.count
  end
end

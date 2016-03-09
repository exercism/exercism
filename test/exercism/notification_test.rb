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
    Notification.on(submission, to: bob, regarding: 'stuff', creator: alice)
    assert_equal 1, Notification.count

    n = Notification.first

    assert_equal submission, n.iteration
    assert_equal bob.id, n.user_id
    assert_equal 'stuff', n.regarding
  end

  def test_increment_existing_notification
    Notification.on(submission, to: bob, regarding: 'stuff', creator: alice)
    Notification.on(submission, to: bob, regarding: 'stuff', creator: alice)

    assert_equal 1, Notification.count
    n = Notification.first

    assert_equal 2, n.count, "Activity count (Submission)"
    refute n.read
  end

  def test_do_not_increment_read_notification
    Notification.on(submission, to: bob, creator: alice)
    assert_equal 1, Notification.count

    Notification.viewed!(submission, bob)

    n2 = Notification.on(submission, to: bob, creator: alice)
    assert_equal 2, Notification.count
    assert_equal 1, n2.count
  end

  def test_do_not_get_notifications_confused_for_users
    charlie = User.create(username: 'charlie')
    Notification.on(submission, to: charlie, creator: alice)
    Notification.on(submission, to: bob, creator: alice)
    assert_equal 2, Notification.count
  end

  def test_do_not_get_notifications_confused_for_topics
    Notification.on(submission, to: bob, regarding: 'kittens', creator: alice)
    Notification.on(submission, to: bob, regarding: 'food', creator: alice)
    assert_equal 2, Notification.count
  end
end


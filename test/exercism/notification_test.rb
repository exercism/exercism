require './test/test_helper'
require 'exercism/problem_set'
require 'exercism/locksmith'
require 'exercism/user'
#require 'exercism/input_sanitation'
require 'exercism/comment'
require 'exercism/submission'
require 'exercism/notification'

class NotificationTest < Minitest::Test

  def teardown
    super
    @alice = nil
    @bob = nil
    @submission = nil
  end

  def alice
    @alice ||= User.create(username: 'alice')
  end

  def bob
    @bob ||= User.create(username: 'bob')
  end

  def submission
    @submission ||= Submission.create(language: 'ruby', slug: 'one', user: alice)
  end

  def test_create_notification
    assert_equal 0, Notification.count
    Notification.on(submission, to: bob)
    assert_equal 1, Notification.count
  end

  def test_reading_a_notification
    notification = Notification.on(submission, to: bob)
    refute notification.read
    notification.read!
    assert notification.read
  end

  def test_created_notification_has_useful_information
    notification = Notification.on(submission, to: bob, regarding: 'stuff')
    assert_equal submission, notification.submission
    assert_equal 'ruby', notification.language
    assert_equal 'one', notification.slug
    assert_equal 'alice', notification.username
    assert_equal 'stuff', notification.regarding
    assert_equal bob, notification.recipient
    assert_equal 1, notification.count
  end

  def test_increment_existing_notification
    Notification.on(submission, to: bob)
    notification = Notification.on(submission, to: bob)
    assert_equal 1, Notification.count, "Total notifications"
    assert_equal 2, notification.count, "Activity count"
    refute notification.read
  end

  def test_do_not_increment_read_notification
    Notification.on(submission, to: bob).read!
    assert_equal 1, Notification.count, 'Total notifications before'
    notification = Notification.on(submission, to: bob)
    assert_equal 2, Notification.count, 'Total notifications after'
    assert_equal 1, notification.count, "Activity count"
    refute notification.read
  end

  def test_do_not_get_notifications_confused_for_users
    charlie = User.create(username: 'charlie')
    Notification.on(submission, to: charlie)
    Notification.on(submission, to: bob)
    assert_equal 2, Notification.count
  end

  def test_do_not_get_notifications_confused_for_topics
    Notification.on(submission, to: bob, regarding: 'kittens')
    Notification.on(submission, to: bob, regarding: 'food')
    assert_equal 2, Notification.count
  end
end


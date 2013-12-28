require './test/active_record_helper'
require 'exercism/user'
require 'exercism/comment'
require 'exercism/submission'
require 'exercism/submission_notification'

class NotificationTest < MiniTest::Unit::TestCase
  include DBCleaner

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
    assert_equal 0, SubmissionNotification.count
    SubmissionNotification.on(submission, to: bob)
    assert_equal 1, SubmissionNotification.count
  end

  def test_reading_a_notification
    notification = SubmissionNotification.on(submission, to: bob)
    refute notification.read
    notification.read!
    assert notification.read
  end

  def test_created_notification_has_useful_information
    notification = SubmissionNotification.on(submission, to: bob, regarding: 'stuff')
    assert_equal submission, notification.submission
    assert_equal 'ruby', notification.language
    assert_equal 'one', notification.slug
    assert_equal 'alice', notification.username
    assert_equal 'stuff', notification.regarding
    assert_equal bob, notification.recipient
    assert_equal 1, notification.count
  end

  def test_increment_existing_notification
    SubmissionNotification.on(submission, to: bob)
    notification = SubmissionNotification.on(submission, to: bob)
    assert_equal 1, SubmissionNotification.count, "Total notifications"
    assert_equal 2, notification.count, "Activity count"
    refute notification.read
  end

  def test_do_not_increment_read_notification
    SubmissionNotification.on(submission, to: bob).read!
    assert_equal 1, SubmissionNotification.count, 'Total notifications before'
    notification = SubmissionNotification.on(submission, to: bob)
    assert_equal 2, SubmissionNotification.count, 'Total notifications after'
    assert_equal 1, notification.count, "Activity count"
    refute notification.read
  end

  def test_do_not_get_notifications_confused_for_users
    charlie = User.create(username: 'charlie')
    SubmissionNotification.on(submission, to: charlie)
    SubmissionNotification.on(submission, to: bob)
    assert_equal 2, SubmissionNotification.count
  end

  def test_do_not_get_notifications_confused_for_topics
    SubmissionNotification.on(submission, to: bob, regarding: 'kittens')
    SubmissionNotification.on(submission, to: bob, regarding: 'food')
    assert_equal 2, SubmissionNotification.count
  end
end


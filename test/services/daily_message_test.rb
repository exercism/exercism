require './test/app_helper'

require 'services/message'
require 'services/daily_message'
require 'mocha/setup'

class DailyMessageTest < Minitest::Test
  include DBCleaner

  attr_reader :alice, :bob, :submission

  def setup
    super
    @alice = User.create(username: 'alice')
    @bob = User.create(username: 'bob', mastery: ['ruby'], email: 'test@exercism.io')
    @submission = Submission.create(language: 'ruby', slug: 'word-count', state: 'pending', user: alice)
  end

  def daily_message
    @daily_message ||= DailyMessage.new(user: bob, intercept_emails: true)
  end

  def test_subject
    Notification.on(submission, to: bob, regarding: 'dogs')
    Notification.on(submission, to: bob, regarding: 'puppies')
    assert_equal 'Daily Digest: 2 notifications, 1 submission needing review', daily_message.subject
  end

  def test_subject_no_notifications
    assert_equal 'Daily Digest: 1 submission needing review', daily_message.subject
  end

  def test_subject_no_submissions
    daily_message.stubs(:pending_submissions).returns([])
    Notification.on(submission, to: bob, regarding: 'dogs')
    assert_equal 'Daily Digest: 1 notification', daily_message.subject
  end

  def test_gets_own_notifications
    daily_message.stubs(:pending_submissions).returns([])
    Notification.on(submission, to: alice, regarding: 'dogs')
    Notification.on(submission, to: bob, regarding: 'dogs')
    assert_equal 'Daily Digest: 1 notification', daily_message.subject
  end

  def test_gets_correct_submissions
    Submission.create(language: 'fake-lang', slug: 'one', state: 'pending', user: alice)
    Notification.on(submission, to: bob, regarding: 'dogs')
    assert_equal 'Daily Digest: 1 notification, 1 submission needing review', daily_message.subject
  end

  def test_doesnt_send_empty_email
    daily_message.stubs(:pending_submissions).returns([])
    daily_message.stubs(:notifications).returns([])
    assert_equal false, daily_message.ship
  end

  def test_sends_email
    Notification.on(submission, to: bob, regarding: 'comment')
    Notification.on(submission, to: bob, regarding: 'nitpick', created_at: 2.hours.ago)
    Submission.create(language: 'javascript', slug: 'word-count', state: 'pending', user: alice)
    Submission.create(language: 'ruby', slug: 'leap', state: 'pending', user: alice, created_at: 1.days.ago)
    daily_message.ship
  end

end

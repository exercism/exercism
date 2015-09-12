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
    assert_equal 2, Notification.count

    n1, n2 = Notification.order('item_type ASC') # Submission, UserExercise

    assert_equal submission, n1.item
    assert_equal bob, n1.recipient
    assert_equal 'stuff', n1.regarding

    assert_equal exercise, n2.item
    assert_equal bob, n2.recipient
    assert_equal 'stuff', n2.regarding
  end

  def test_create_notification_on_exercise
    assert_equal 0, Notification.count
    Notification.on(exercise, to: bob, regarding: 'stuff', creator: alice)
    assert_equal 2, Notification.count

    n1, n2 = Notification.order('item_type ASC') # Submission, UserExercise

    assert_equal submission, n1.item
    assert_equal bob, n1.recipient
    assert_equal 'stuff', n1.regarding

    assert_equal exercise, n2.item
    assert_equal bob, n2.recipient
    assert_equal 'stuff', n2.regarding
  end

  def test_create_notifications_on_related_submission
    s1 = submission
    s2 = Submission.create(language: 'ruby', slug: 'one', user: alice)
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'one').update

    Notification.on(s1.reload, to: bob, regarding: 'stuff', creator: alice)
    Notification.on(s2.reload, to: bob, regarding: 'stuff', creator: alice)

    assert_equal 3, Notification.count
    n1, n2, n3 = Notification.order('item_type ASC') # Submission, Submission, UserExercise

    assert_equal 1, n1.count
    assert_equal 1, n2.count
    assert_equal 2, n3.count
  end

  def test_reading_a_submission_notification
    Notification.on(submission, to: bob, creator: alice)

    n1, n2 = Notification.order('item_type ASC') # Submission, UserExercise
    refute n1.read
    refute n2.read
    n1.read!
    assert n1.reload.read
    assert n2.reload.read
  end

  def test_reading_an_exercise_notification
    Notification.on(exercise, to: bob, creator: alice)

    n1, n2 = Notification.order('item_type ASC') # Submission, UserExercise
    refute n1.read
    refute n2.read
    n2.read!
    assert n1.reload.read
    assert n2.reload.read
  end

  def test_increment_existing_notification
    Notification.on(submission, to: bob, regarding: 'stuff', creator: alice)
    Notification.on(submission, to: bob, regarding: 'stuff', creator: alice)

    assert_equal 2, Notification.count, "Total notifications"
    n1, n2 = Notification.order('item_type ASC') # Submission, UserExercise

    assert_equal 2, n1.count, "Activity count (Submission)"
    assert_equal 2, n2.count, "Activity count (UserExercise)"
    refute n1.read
    refute n2.read
  end

  def test_do_not_increment_read_notification
    Notification.on(submission, to: bob, creator: alice).read!
    assert_equal 2, Notification.count, 'Total notifications before'
    notification = Notification.on(submission, to: bob, creator: alice)
    assert_equal 4, Notification.count, 'Total notifications after'
    assert_equal 1, notification.count, "Activity count"
    refute notification.read
  end

  def test_do_not_get_notifications_confused_for_users
    charlie = User.create(username: 'charlie')
    Notification.on(submission, to: charlie, creator: alice)
    Notification.on(submission, to: bob, creator: alice)
    assert_equal 4, Notification.count
  end

  def test_do_not_get_notifications_confused_for_topics
    Notification.on(submission, to: bob, regarding: 'kittens', creator: alice)
    Notification.on(submission, to: bob, regarding: 'food', creator: alice)
    assert_equal 4, Notification.count
  end
end


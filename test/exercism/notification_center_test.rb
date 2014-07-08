require_relative '../active_record_helper'
require 'exercism/user'
require 'exercism/notification'
require 'exercism/notification_center'

class NotificationCenterTest < Minitest::Test
  include DBCleaner

  def test_garbage_collection
    alice = User.create
    Notification.create(user_id: alice.id, item_id: 1, read: true)
    Notification.create(user_id: alice.id, item_id: 2, read: false)
    Notification.create(user_id: alice.id, item_id: 3, read: true)
    NotificationCenter.new(alice).gc
    assert_equal [2], alice.notifications.map(&:item_id)
  end

  def test_delete_unread_notification
    alice = User.create
    notification = Notification.create(user_id: alice.id, read: false)
    NotificationCenter.new(alice).delete(notification.id)
    assert_equal [notification.id], alice.notifications.map(&:id)
  end

  def test_delete_read_notification
    alice = User.create
    notification = Notification.create(user_id: alice.id, read: true)
    NotificationCenter.new(alice).delete(notification.id)
    assert alice.notifications.empty?
  end
end

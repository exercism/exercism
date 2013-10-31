require './test/api_helper'

class NotificationsApiTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismAPI
  end

  def teardown
    super
    @alice = nil
    @submission = nil
  end

  def alice
    @alice ||= User.create(username: 'alice', github_id: 1)
  end

  def submission
    @submission ||= Submission.create(language: 'ruby', slug: 'bob', user: alice)
  end

  def test_notifications_are_protected
    get '/notifications'
    assert_equal 401, last_response.status
  end

  def test_get_notifications_using_api_key
    Notification.on(submission, to: alice, regarding: 'nitpick')
    get '/notifications', key: alice.key
    notifications = JSON.parse(last_response.body)['notifications']
    assert_equal 1, notifications.size
    assert_equal "/submissions/#{submission.key}", notifications.first['notification']['link']
  end

  def test_get_notifications_when_logged_in
    Notification.on(submission, to: alice, regarding: 'nitpick')
    get '/notifications', {}, login(alice)
    notifications = JSON.parse(last_response.body)['notifications']
    assert_equal 1, notifications.size
    assert_equal "/submissions/#{submission.key}", notifications.first['notification']['link']
  end

  def test_updating_read_status_is_restricted
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    put "/notifications/#{notification.id}"
    assert_equal 401, last_response.status
    refute notification.reload.read
  end

  def test_mark_notification_as_read_when_logged_in
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    put "/notifications/#{notification.id}", {}, login(alice)
    assert notification.reload.read
  end

  def test_mark_notification_as_read_using_api_key
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    put "/notifications/#{notification.id}", key: alice.key
    assert notification.reload.read
  end
end


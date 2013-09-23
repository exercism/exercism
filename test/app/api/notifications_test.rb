require './test/api_helper'

class NotificationsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  def login(user)
    set_cookie("_exercism_login=#{user.github_id}")
  end

  def alice
    @alice ||= User.create(username: 'alice', github_id: 1)
  end

  def submission
    @submission ||= Submission.create(language: 'ruby', slug: 'bob', user: alice)
  end

  def teardown
    Mongoid.reset
    @alice = nil
    @submission = nil
  end

  def test_notifications_are_protected
    get '/api/v1/notifications'
    assert_equal 401, last_response.status
  end

  def test_get_notifications_using_shared_secret
    Notification.on(submission, to: alice, regarding: 'nitpick')
    get '/api/v1/notifications', key: alice.key
    notifications = JSON.parse(last_response.body)['notifications']
    assert_equal 1, notifications.size
    assert_equal "/submissions/#{submission.id}", notifications.first['notification']['link']
  end

  def test_get_notifications_when_logged_in
    Notification.on(submission, to: alice, regarding: 'nitpick')
    login(alice)
    get '/api/v1/notifications'
    notifications = JSON.parse(last_response.body)['notifications']
    assert_equal 1, notifications.size
    assert_equal "/submissions/#{submission.id}", notifications.first['notification']['link']
  end

  def test_updating_read_status_is_restricted
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    put "/api/v1/notifications/#{notification.id}"
    assert_equal 401, last_response.status
    refute notification.reload.read
  end

  def test_mark_notification_as_read_when_logged_in
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    login(alice)
    put "/api/v1/notifications/#{notification.id}"
    assert notification.reload.read
  end

  def test_mark_notification_as_read_using_shared_secret
    notification = Notification.on(submission, to: alice, regarding: 'nitpick')
    put "/api/v1/notifications/#{notification.id}", key: alice.key
    assert notification.reload.read
  end
end


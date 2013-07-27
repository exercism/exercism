require './test/api_helper'

class NotificationsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create(username: 'alice', github_id: 1, current: {'ruby' => 'word-count', 'javascript' => 'anagram'})
    Notification.create(user: @alice ,unread: true, from: "Bob", type: "argument")
  end

  def teardown
    Mongoid.reset
  end

  def logged_in
    { github_id: @alice.github_id }
  end

  def not_logged_in
    { github_id: nil }
  end

  def test_get_notifications_when_logged_in
    skip
    get '/api/v1/notifications', {}, 'rack.session' => logged_in
    assert last_response.body.include?("Bob")
  end

  def test_get_notifications_when_not_logged_in
    get '/api/v1/notifications', {}, 'rack.session' => not_logged_in
    assert last_response.body.empty?
  end

  def test_get_notifications_from_cli
  end

  def test_mark_notification_read_when_logged_in
  end

  def test_mark_notification_read_when_not_logged_in
  end

  def test_mark_notification_from_cli
  end
end


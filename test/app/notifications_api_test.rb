require './test/api_helper'

class NotificationsApiTest < Minitest::Test
  include Rack::Test::Methods

  def app
    ExercismApp
  end

  attr_reader :alice
  def setup
    @alice = User.create({
      username: 'alice',
      github_id: 1,
      current: {'ruby' => 'word-count', 'javascript' => 'anagram'}
    })
    @notification = Notification.create({
      user: @alice,
      unread: true,
      from: "Bob",
      type: "argument",
      kind: "Nitpick",
      link: "a/link/to/a/thing",
    })
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

  def cli_params
    { key: @alice.key }
  end

  def test_get_notifications_when_logged_in
    get '/api/v1/notifications', {}, 'rack.session' => logged_in
    assert last_response.body.include?("Bob")
    assert last_response.body.include?("just now")
  end

  def test_get_notifications_when_not_logged_in
    get '/api/v1/notifications', {}, 'rack.session' => not_logged_in
    assert_equal 401, last_response.status
  end

  def test_get_notifications_from_cli
    get '/api/v1/notifications', cli_params
    assert last_response.body.include?("just now")
  end

  def test_mark_notification_read_when_logged_in
    post "/api/v1/notifications/#{@notification.id}", {}, 'rack.session' => logged_in
    assert_equal 200, last_response.status
  end

  def test_mark_notification_read_when_not_logged_in
    skip
  end

  def test_mark_notification_from_cli
    skip
  end
end


require './test/api_helper'
require './lib/legacy'

class LegacyNotificationsApiTest < MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismLegacy::App
  end

  attr_reader :alice, :bob, :submission
  def setup
    super
    @alice = User.create(username: 'alice', github_id: 1)
    @bob = User.create(username: 'bob')
    @submission = Submission.create(language: 'ruby', slug: 'bob', user: alice)
    Hack::UpdatesUserExercise.new(alice.id, 'ruby', 'bob').update
    @submission.reload
  end

  def test_notifications_are_protected
    get '/'
    assert_equal 401, last_response.status
  end

  def test_get_notifications_when_logged_in
    Notification.on(submission, to: alice, regarding: 'nitpick', creator: bob)
    get '/', {}, login(alice)
    notifications = JSON.parse(last_response.body)['notifications']
    assert_equal 1, notifications.size
    assert_equal "/submissions/#{submission.key}", notifications.first['notification']['link']
  end

  def test_updating_read_status_is_restricted
    notification = Notification.on(submission, to: alice, regarding: 'nitpick', creator: bob)
    put "/#{notification.id}"
    assert_equal 401, last_response.status
    refute notification.reload.read
  end

  def test_mark_notification_as_read_when_logged_in
    notification = Notification.on(submission, to: alice, regarding: 'nitpick', creator: bob)
    put "/#{notification.id}", {}, login(alice)
    assert notification.reload.read
  end
end


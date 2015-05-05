require './test/app_helper'

class AppNotificationsTest < Minitest::Test
  include Rack::Test::Methods
  include AppTestHelper
  include DBCleaner

  def app
    ExercismWeb::App
  end

  def test_notifications_page
    alice = User.create(username: 'alice', github_id: 1)
    attributes = {
      user_id: alice.id,
      url: '/',
      text: 'This is the test.',
      link_text: 'Read more.'
    }
    Alert.create(attributes)
    get '/notifications', {}, login(alice)
    assert_match(/This is the test/, last_response.body)
  end

  def test_delete_alert
    alice = User.create(username: 'alice', github_id: 1)
    attributes = {
      user_id: alice.id,
      url: '/',
      text: 'This is the test.',
      link_text: 'Read more.'
    }
    alert = Alert.create(attributes)
    delete "/notifications/alert-#{alert.id}", {}, login(alice)
    assert_equal 302, last_response.status
    assert_equal 0, Alert.count
  end
end

require_relative '../test_helper'
require 'active_support'
require 'active_support/core_ext/object'
require 'exercism/client_version'
require 'mocha/mini_test'

module ExercismWeb
  class ClientVersionTest < Minitest::Test
    def test_notice_when_client_outdated_not_dismissed
      dismissed_at = nil
      user = stub(:user)
      user.stubs(username: 'been', guest?: false, client_version_update_notification_dismissed_at: dismissed_at)
      client_version = ClientVersion.new(user: user)
      assert client_version.notice_when_client_outdated.present?, "Expected a notice when not dismissed"
    end

    def test_notice_when_client_outdated_dismissed
      dismissed_at = Time.now
      user = stub(:user)
      user.stubs(username: 'been', guest?: false, client_version_update_notification_dismissed_at: dismissed_at)
      client_version = ClientVersion.new(user: user)
      assert client_version.notice_when_client_outdated.blank?, "Expected no notice after dismissed"
    end

    def test_notice_when_client_outdated_for_guest
      dismissed_at = Time.now
      user = stub(:user)
      user.stubs(guest?: true)
      client_version = ClientVersion.new(user: user)
      assert client_version.notice_when_client_outdated.blank?, "Expected no notice after dismissed"
    end
  end
end

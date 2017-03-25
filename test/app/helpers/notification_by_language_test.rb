require_relative '../../integration_helper'
require_relative '../../../app/helpers/notification_by_language'

class AppHelpersNotificationByLanguageTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @kara       = User.create(username: 'kara', email: 'kara@example.com')
    @oliver     = User.create(username: 'oliver', email: 'oliver@example.com')
    @submission = Submission.create(user: @kara)
  end

  def helper
    @helper ||= Object.new.extend(ExercismWeb::Helpers::NotificationByLanguage)
  end

  def test_notification_by_language_empty
    empty_hash = Hash.new { |h,k| h[k] = [] }
    assert_equal empty_hash, helper.notification_by_language([])
  end

  def test_notification_by_language_many
    submission = Submission.create(language: 'animal', slug: "rainbow", user: @kara)
    Notification.on(submission, user_id: @oliver.id, action: 'iteration', actor_id: @kara.id)
    assert_equal 1, helper.notification_by_language(@oliver.notifications)['Animal'].count
  end
end

require_relative '../../integration_helper'
require_relative '../../../app/helpers/notification_by_language'

class AppHelpersNotificationByLanguageTest < Minitest::Test
  include DBCleaner

  def setup
    super
    @alice      = User.create(username: 'alice', email: 'alice@example.com')
    @fred       = User.create(username: 'fred', email: 'fred@example.com')
    @submission = Submission.create(user: @alice)
  end

  def helper
    return @helper if @helper
    @helper = Object.new
    @helper.extend(ExercismWeb::Helpers::NotificationByLanguage)
    @helper
  end

  def test_notification_by_language_empty
    empty_hash = Hash.new([])
    assert_equal empty_hash, helper.notification_by_language([])
  end

  def test_notification_by_language_many
    langs = ['ruby', 'clojure', 'javascript']
    actions = ['comment', 'iteration', 'mention', 'like']
    10.times do |i|
      submission = Submission.create(language: langs[i%3], slug: "Test #{i}", user: @alice)
      Notification.on(submission, user_id: @fred.id, action: actions[i%4], actor_id: @alice.id)
    end
    assert_equal 4, helper.notification_by_language(@fred.notifications)['Ruby'].count
  end

end

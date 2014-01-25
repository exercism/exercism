namespace :notifications do
  desc "delete old, read notifications"
  task :cleanup do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Notification.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
    Alert.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
  end

  desc "delete hibernation notifications"
  task :delete_hibernated do
    require 'active_record'
    require 'db/connection'
    DB::Connection.establish

    sql = "DELETE FROM notifications WHERE regarding='hibernating'"
    ActiveRecord::Base.connection.execute(sql)
  end

  desc "copy hibernation notifications to system alerts"
  task :migrate_hibernation_alerts do
    require 'active_record'
    require 'db/connection'
    require './lib/exercism/alert'
    require './lib/exercism/notification'
    require './lib/exercism/submission_notification'
    require './lib/exercism/user'
    DB::Connection.establish

    Notification.where(regarding: 'hibernating').where('alert_id IS NULL').find_each do |notification|
      print '.'
      submission = notification.submission
      attributes = {
        user_id: notification.user_id,
        read: notification.read,
        url: ['', notification.user.username, submission.user_exercise.key].join('/'),
        link_text: "View submission.",
        text: "Your exercise #{submission.slug} in #{submission.language} has gone into hibernation.",
        created_at: notification.created_at
      }
      alert = Alert.create(attributes)
      notification.update_attributes(alert_id: alert.id)
    end
  end
end

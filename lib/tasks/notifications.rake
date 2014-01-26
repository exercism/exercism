namespace :notifications do
  desc "delete old, read notifications"
  task :cleanup do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Notification.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
    Alert.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
  end

  namespace :migrate do
    desc "migrate STI to polymorphic association"
    task :item_type do
      require 'active_record'
      require 'db/connection'
      DB::Connection.establish

      sql = "UPDATE notifications SET item_type='Submission' WHERE type='SubmissionNotification'"
      ActiveRecord::Base.connection.execute(sql)

      sql = "UPDATE notifications SET item_type='Team' WHERE type='TeamNotification'"
      ActiveRecord::Base.connection.execute(sql)
    end
  end
end

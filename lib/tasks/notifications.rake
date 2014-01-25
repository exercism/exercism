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
end

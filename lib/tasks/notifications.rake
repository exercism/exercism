namespace :notifications do
  desc "delete old, read notifications"
  task :cleanup do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Notification.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
  end
end

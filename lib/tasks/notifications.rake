namespace :notifications do
  desc "delete old, read notifications"
  task :cleanup do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Notification.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
    Alert.where('created_at < ?', (Date.today - 2)).where(:read => true).delete_all
  end

  namespace :sync do
    desc "synchronize notifications submission -> exercise"
    task :submission_notifications do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/notification'
      require './lib/exercism/submission'
      require './lib/exercism/user_exercise'
      require './lib/exercism/user'
      require './lib/tasks/notifications/sync'

      DB::Connection.establish

      UserExercise.find_each do |exercise|
        print '.'
        Hack::Notifications::Sync.new(exercise).process
      end
      puts
    end
  end

end

namespace :notifications do
  desc "delete old, read notifications"
  task :cleanup do
    require 'bundler'
    Bundler.require
    require 'exercism'

    Notification.where('created_at < ?', (Date.today - 2)).where(read: true).delete_all
    Alert.where('created_at < ?', (Date.today - 2)).where(read: true).delete_all
  end

  desc "alert everyone about new notification page"
  task :alerts do
    require 'bundler'
    Bundler.require
    require 'exercism'

    User.all.find_each do |user|
      attributes = {
        user_id: user.id,
        text: "Does the new notifications page work for you? If you have thoughts, please ",
        link_text: "join the discussion on GitHub.",
        url: "https://github.com/exercism/exercism.io/issues/1559",
      }
      Alert.create(attributes)
    end
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

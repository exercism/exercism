namespace :digest do
  desc "Sends digest email of Notifications/Submissions to users"
  task :send_emails do
    require 'bundler'
    Bundler.require
    require 'exercism'
    require 'app/presenters/workload'
    require 'services'
    require 'services/notification_message'
    env = ENV.fetch('RACK_ENV') { 'development' }
    intercept = env != 'production'

    # Send daily notification email to all users with notifications in
    # past 24 hours
    user_ids = Notification.on_submissions.unread.where('created_at >= ?', 1.days.ago).pluck(:user_id).uniq

    User.where('email IS NOT NULL').where(id: user_ids).find_each do |user|
      begin
        NotificationMessage.new(user: user, intercept_emails: intercept).ship
      rescue => e
        # Ignore errors. Really must add monitoring.
      end
    end
  end
end

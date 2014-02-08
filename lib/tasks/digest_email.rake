namespace :digest do
  desc "Sends digest email of Notifications/Submissions to users"
  task :send_emails do
    require 'bundler'
    Bundler.require
    require 'exercism'
    require 'app/presenters/workload'
    require 'services'
    require 'services/notification_message'

    # Send daily notification email to all users with notifications in
    # past 24 hours
    user_ids = Notification.on_submissions.unread.where('created_at >= ?', 1.days.ago).pluck(:user_id).uniq

    user_ids.each do |user_id|
      user = User.find(user_id)
      NotificationMessage.new(user: user).ship if user.email
    end
  end
end

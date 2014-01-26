namespace :teams do
  namespace :migrate do
    desc "copy invitation notifications into system alerts"
    task :invitation_alerts do
      require 'active_record'
      require 'db/connection'
      require './lib/exercism/alert'
      require './lib/exercism/user'
      require './lib/exercism/team'
      require './lib/exercism/team_notification'
      DB::Connection.establish

      Notification.where(regarding: 'invitation').find_each do |notification|
        print '.'
        attributes = {
          read: notification.read,
          user_id: notification.user_id,
          created_at: notification.created_at,
          url: '/account',
          text: "#{notification.team.creator.username} would like you to join the team #{notification.team.name}. You can accept the invitation",
          link_text: 'on your account page.'
        }
        Alert.create(attributes)
      end
    end
  end
end

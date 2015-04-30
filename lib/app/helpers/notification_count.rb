module ExercismWeb
  module Helpers
    module NotificationCount
      def notification_count
        sql = "SELECT COUNT(note.id) AS tally FROM notifications note INNER JOIN submissions sub ON note.item_id=sub.id WHERE note.item_type='Submission' AND note.user_id=#{current_user.id} AND note.read='f'"

        notifications_count = ActiveRecord::Base.connection.execute(sql).to_a.first["tally"].to_i
        alert_count = current_user.alerts.count
        unconfirmed_memberships_count = current_user.unconfirmed_team_memberships.count

        notifications_count + alert_count + unconfirmed_memberships_count
      end
    end
  end
end

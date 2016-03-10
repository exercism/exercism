module ExercismWeb
  module Helpers
    module NotificationCount
      def notification_count
        sql = "SELECT COUNT(note.id) AS tally FROM notifications note INNER JOIN submissions sub ON note.iteration_id=sub.id WHERE note.user_id=#{current_user.id} AND note.read='f'"

        notifications_count = ActiveRecord::Base.connection.execute(sql).to_a.first["tally"].to_i
        unconfirmed_memberships_count = current_user.unconfirmed_team_memberships.count

        notifications_count + unconfirmed_memberships_count
      end
    end
  end
end

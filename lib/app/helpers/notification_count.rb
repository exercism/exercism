module ExercismWeb
  module Helpers
    module NotificationCount
      def notification_count
        sql = "SELECT COUNT(note.id) AS tally FROM notifications note INNER JOIN submissions sub ON note.item_id=sub.id WHERE note.item_type='Submission' AND note.user_id=#{current_user.id} AND note.read='f'"
        ActiveRecord::Base.connection.execute(sql).to_a.first["tally"].to_i + current_user.alerts.count
      end
    end
  end
end

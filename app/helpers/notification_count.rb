module ExercismWeb
  module Helpers
    module NotificationCount
      # rubocop:disable Metrics/AbcSize
      def notification_count
        sql = "SELECT COUNT(note.id) FROM notifications note INNER JOIN submissions sub ON note.iteration_id=sub.id WHERE note.user_id=#{current_user.id} AND note.read='f'"

        notifications_count = ActiveRecord::Base.connection.select_value(sql).to_i
        membership_invites_count = current_user.team_membership_invites.count

        membership_requests_count = TeamMembershipRequest.where(
          team_id: current_user.managed_teams.ids,
          refused: false
        ).count

        notifications_count + membership_invites_count + membership_requests_count
      end
    end
  end
end

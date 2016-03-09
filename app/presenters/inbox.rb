module ExercismWeb
  module Presenters
    class Inbox
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def count
        notifications.count + unconfirmed_team_memberships.count
      end

      def has_notifications?
        notifications.count > 0
      end

      def has_unconfirmed_team_memberships?
        unconfirmed_team_memberships.count > 0
      end

      def notifications
        user.notifications.on_submissions.unread.recent.reject {|note| note.item.nil? || note.item.user.nil?}
      end

      def unconfirmed_team_memberships
        user.unconfirmed_team_memberships
      end
    end
  end
end

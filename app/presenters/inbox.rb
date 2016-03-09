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
        user.notifications.unread.recent.reject {|note| note.iteration.nil? || note.iteration.user.nil?}
      end

      def unconfirmed_team_memberships
        user.unconfirmed_team_memberships
      end
    end
  end
end

module ExercismWeb
  module Presenters
    class Inbox
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def alerts
        user.alerts
      end

      def has_alerts?
        user.alerts.count > 0
      end

      def notifications
        user.notifications.on_submissions.unread.recent
      end
    end
  end
end

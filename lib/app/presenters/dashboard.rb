module ExercismWeb
  module Presenters
    class Dashboard
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def pay_it_forward?
        !!suggestion
      end

      def suggestion
        @suggestion ||= Work.new(user).random
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications.unread.personal
      end
    end
  end
end

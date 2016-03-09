module ExercismWeb
  module Presenters
    class Dashboard
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def current_exercises
        user.exercises.current
      end

      def unsubmitted_exercises
        user.exercises.unsubmitted
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications.unread.personal.reject {|note| note.item.nil? || note.item.user.nil?}
      end
    end
  end
end

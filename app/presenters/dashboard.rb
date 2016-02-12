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

      def unsubmitted_grouped_exercises
        user.exercises.unsubmitted.group_by { |ex| ex.language }
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications.includes(:iteration, :actor).unread.feedback.reject {|note| note.iteration.nil? || note.iteration.user.nil?}
      end
    end
  end
end

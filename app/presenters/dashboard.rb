module ExercismWeb
  module Presenters
    class Dashboard
      attr_reader :user
      def initialize(user)
        @user = user
      end

      def current_exercises
        @current_exercises ||= user.exercises.current
      end

      def has_activity?
        notifications.count > 0
      end

      def notifications
        @notifications ||= user.notifications
                               .includes(:actor, iteration: [:comments])
                               .unread.feedback
                               .reject { |note| note.iteration.nil? || note.iteration.user.nil? }
      end
    end
  end
end

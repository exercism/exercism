module ExercismIO
  module Presenters
    class Navigation
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def picture
        user.avatar_url + "?s=100"
      end

      def username
        user.username
      end

      def team_count
        "%02d" % teams.count
      end

      def teams
        @teams ||= user.teams | user.managed_teams
      end

      def exercise_count
        "%02d" % exercises.count
      end

      def exercises
        active_exercises.map {|exercise|
          ExercismIO::Presenters::ActiveExercise.new(exercise, personal_notification(exercise))
        }
      end

      def conversation_count
        "%02d" % general_notifications.unread.count
      end

      def conversations
        general_notifications.map {|note| ExercismIO::Presenters::Notification.new(note)}
      end

      def has_alerts?
        alerts.count > 0
      end

      def alerts
        user.alerts
      end

      private

      def active_exercises
        user.exercises.active
      end

      def general_notifications
        user.notifications.on_exercises.general.by_recency
      end

      def personal_notifications
        user.notifications.on_exercises.personal.unread.by_recency
      end

      def personal_notification(exercise)
        personal_notifications.find {|note| note.item_id == exercise.id }
      end
    end
  end
end

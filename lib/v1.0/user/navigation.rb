module App
  module User
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
        @teams ||= user.teams | user.teams_created
      end

      def exercise_count
        "%02d" % exercises.count
      end

      def exercises
        active_exercises.map {|exercise| App::User::ActiveExercise.new(exercise, alert(exercise))}
      end

      def notifications
        personal_notifications
      end

      def conversation_count
        "%02d" % general_notifications.unread.count
      end

      def conversations
        general_notifications.map {|note| App::User::Notification.new(note)}
      end

      private

      def general_notifications
        user.notifications.on_exercises.general.by_recency
      end

      def personal_notifications
        user.notifications.on_exercises.personal.unread.by_recency
      end

      def active_exercises
        user.exercises.active
      end

      def alert(exercise)
        personal_notifications.find {|note| note.item_id == exercise.id }}
      end
    end
  end
end

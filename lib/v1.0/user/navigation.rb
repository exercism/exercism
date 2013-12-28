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
        @exercises ||= user.exercises.active
      end

      def conversation_count
        "%02d" % notifications.unread.count
      end

      def alerts
        user.notifications.personal.unread.by_recency
      end

      def conversations
        notifications.map {|note| App::User::Notification.new(note)}
      end

      private

      def notifications
        user.notifications.general.by_recency
      end
    end
  end
end

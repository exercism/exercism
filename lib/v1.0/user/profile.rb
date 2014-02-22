module App
  module User
    class Profile
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def username
        user.username
      end

      def github_url
        "https://github.com/#{username}"
      end

      def active_exercises
        user.exercises.active.map {|e| App::User::Exercise.new(e)}
      end

      def completed_in_tracks
        App::User::TruncatedExercises.by_track(user.exercises.completed)
      end
    end
  end
end

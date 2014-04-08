module ExercismIO
  module Presenters
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
        user.exercises.active.map {|ex| ExercismIO::Presenters::ExerciseLink.new(ex)}
      end

      def completed_by_track
        user.exercises.completed.group_by(&:language).map do |language, exercises|
          ExercismIO::Presenters::Track.new(language, exercises)
        end
      end
    end
  end
end

module ExercismIO
  module Presenters
    class Track
      include Named

      attr_reader :language, :user_exercises
      def initialize(language, user_exercises)
        @language = language
        @user_exercises = user_exercises
      end

      def exercises
        @exercises ||= user_exercises.map {|ex| ExercismIO::Presenters::ExerciseLink.new(ex)}
      end

      private

      def slug
        language
      end
    end
  end
end

module App
  module User
    class Track
      include Named

      attr_reader :language
      def initialize(language, exercises)
        @language = language
        @exercises = exercises
      end

      def more?
        @exercises.count > limit
      end

      def exercises
        @exercises.first(limit)
      end

      def limit
        5
      end

      private

      def slug
        language
      end
    end
  end
end

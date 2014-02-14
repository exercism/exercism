module App
  module User
    class Track
      include Named

      attr_reader :language, :exercises
      def initialize(language, exercises)
        @language = language
        @exercises = exercises
      end

      private

      def slug
        language
      end
    end
  end
end

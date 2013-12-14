module API
  module Assignments
    class Demo
      attr_reader :curriculum
      def initialize(curriculum)
        @curriculum = curriculum
      end

      def assignments
        @assignments ||= assign
      end

      private

      def assign
        curriculum.trails.map do |_, trail|
          first_in(trail)
        end
      end

      def first_in(trail)
        Assignment.new(trail.language, trail.exercises.first.slug, curriculum.path)
      end
    end
  end
end

module ExercismWeb
  module Presenters
    class Languages
      def self.all
        @all ||= X::Track.all
      end

      def self.active
        all.select(&:active)
      end
    end
  end
end

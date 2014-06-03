module ExercismWeb
  module Presenters
    class Languages
      attr_reader :names

      def initialize(names)
        @names = names
      end

      def count
        names.length
      end

      def to_s
        case count
        when 1
          names.first
        when 2
          names.join(' and ')
        else
          *most, last = names
          [most.join(', '), last].join(', and ')
        end
      end
    end
  end
end

module App
  module Site
    class Languages
      attr_reader :names

      def initialize(names)
        @names = names
      end

      # This won't work for 1 and 2
      def to_s
        *most, last = names
        [most.join(', '), last].join(', and ')
      end
    end
  end
end


module X
  class Todo
    class Exercise
      PROPERTIES = %w(slug data readme_url implementations blurb).freeze

      attr_reader(*PROPERTIES)

      def initialize(data)
        PROPERTIES.each do |property|
          instance_variable_set(:"@#{property}", data[property])
        end
      end

      def name
        slug.split('-').map(&:capitalize).join(' ')
      end
    end
  end
end

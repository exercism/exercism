module X
  class Todo
    class Exercise
      PROPERTIES = [:slug, :data, :readme_url, :implementations, :blurb].freeze

      attr_reader(*PROPERTIES)

      def initialize(data)
        PROPERTIES.each do |property|
          instance_variable_set(:"@#{property}", data[property.to_s])
        end
      end

      def name
        slug.split('-').map(&:capitalize).join(' ')
      end
    end
  end
end

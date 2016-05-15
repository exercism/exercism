module X
  class Todo
    class Exercise
      METHODS = [
        :slug, :data, :readme_url,
        :implementations, :blurb
      ]

      attr_reader(*METHODS)
      def initialize(data)
        METHODS.each do |name|
          instance_variable_set(:"@#{name}", data[name.to_s])
        end
      end

      def name
        slug.split('-').map(&:capitalize).join(' ')
      end
    end
  end
end

module X
  class Todo
    class Exercise
      METHODS = [
        :slug, :readme, :data,
        :implementations
      ]

      attr_reader(*METHODS)
      def initialize(data)
        METHODS.each do |name|
          instance_variable_set(:"@#{name}", data[name.to_s])
        end
      end
    end
  end
end

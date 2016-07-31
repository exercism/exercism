module X
  class Todo
    def self.track(id)
      _, body = X::Xapi.get('tracks', id, 'todo')
      new(JSON.parse(body))
    end

    METHODS = [
      :todos, :language, :track_id, :repository
    ].freeze

    attr_reader(*METHODS)

    def initialize(data)
      METHODS.each do |name|
        instance_variable_set(:"@#{name}", data[name.to_s])
      end
      @todos = data['todos'].inject([]) do |array, problem|
        array << Todo::Exercise.new(problem)
      end
    end

    def with_implementations
      todos.select { |x| x.implementations.any? }
           .sort_by { |x| x.implementations.count }
           .reverse
    end

    def any?
      todos.any?
    end
  end
end

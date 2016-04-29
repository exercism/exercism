module X
  class Todo
    def self.track(id)
      _, body = X::Xapi.get('tracks', id, 'todo')
      new(JSON.parse(body)['todos'])
    end

    attr_reader :todos

    def initialize(data)
      @todos = data.inject([]) do |array, problem|
                 array << Todo::Exercise.new(problem)
               end
    end

    def any?
      todos.any?
    end
  end
end

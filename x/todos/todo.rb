require 'forwardable'
require_relative '../errors'

module X
  class Todo
    include Enumerable
    extend Forwardable

    def_delegators :@exercises, :each

    PROPERTIES = [:language, :track_id, :repository].freeze

    attr_reader(*PROPERTIES, :exercises)

    def self.track(id)
      code, body = X::Xapi.get('tracks', id, 'todo')
      case code
      when 200
        new(JSON.parse(body))
      else
        fail LanguageNotFound.new(code: code, body: body, track_id: id)
      end
    end

    def initialize(data)
      PROPERTIES.each { |name| instance_variable_set(:"@#{name}", data[name.to_s]) }
      @exercises = data['todos'].map { |problem| Todo::Exercise.new(problem) }
    end
  end
end

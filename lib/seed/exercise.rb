module Seed
  class Exercise
    attr_reader :language, :slug, :size
    def initialize(language, slug, options = {})
      @language, @slug = language, slug
      @done = options.fetch(:done) { true }
      @size = options.fetch(:attempts) { rand(1..12) }
    end

    def attempts
      @attempts ||= generate_attempts
    end

    private

    def done?
      @done
    end

    def timeline
      @timeline ||= Timeline.new(size)
    end

    def generate_attempts
      attempts = []
      states = Array.new(size - 1, 'superseded').push last_state
      timeline.events.zip(states).each do |event, state|
        attempts << Seed::Attempt.new(language, slug, event, state)
      end
      attempts
    end

    def last_state
      done? ? 'done' : 'pending'
    end
  end
end

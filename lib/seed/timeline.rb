module Seed
  class Timeline
    attr_reader :size

    def initialize(size)
      @size = size
    end

    def events
      @events ||= generate_events
    end

    private

    def generate_events
      events = []
      event = nil
      size.times do
        event = event_before(event)
        events << event
      end
      events.reverse
    end

    def event_before(previous)
      (previous || Time.now) - seconds_ago
    end

    def seconds_ago
      rand(1000..10000)
    end
  end
end

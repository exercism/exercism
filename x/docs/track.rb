module X
  module Docs
    # Enhances the track-specific documentation, adding
    # defaults where missing and embellishments that encourage
    # people to submit improvements.
    class Track
      TOPICS = [:about, :tests, :installation, :learning, :resources]

      attr_reader(*TOPICS)
      def initialize(data, repository)
        @data = data
        @repository = repository

        TOPICS.each do |topic|
          instance_variable_set(:"@#{topic}", value(topic.to_s))
        end
      end

      private
      attr_reader :repository, :data

      def value(topic)
        if data[topic].empty?
          read(topic).gsub('REPO', repository)
        else
          [data[topic].strip, better(topic)].join("\n")
        end
      end

      def better(topic)
        read('better').gsub('REPO', repository).gsub('TOPIC', topic.upcase)
      end

      def read(topic)
        File.read("./x/docs/md/track/#{topic.upcase}.md")
      end
    end
  end
end

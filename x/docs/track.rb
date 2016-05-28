module X
  module Docs
    # Enhances the track-specific documentation, adding
    # defaults where missing and embellishments that encourage
    # people to submit improvements.
    class Track
      TOPICS = [:about, :tests, :installation, :learning, :resources].freeze

      attr_reader(*TOPICS)
      def initialize(data, repository, doc_ext)
        @data = data
        @repository = repository
        @doc_ext = doc_ext

        TOPICS.each do |topic|
          instance_variable_set(:"@#{topic}", value(topic.to_s))
        end
      end

      private

      attr_reader :repository, :data, :doc_ext

      def value(topic)
        if data[topic].empty?
          read(topic).gsub('REPO', repository)
        else
          [data[topic].strip, better(topic)].join("\n")
        end
      end

      def better(topic)
        read('better').gsub('REPO', repository).gsub('TOPIC', topic.upcase).gsub('EXT', doc_ext)
      end

      def read(topic)
        File.read("./x/docs/md/track/#{topic.upcase}.md")
      end
    end
  end
end

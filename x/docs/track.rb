module X
  module Docs
    class Track
      attr_reader :track
      def initialize(track)
        @track = track
      end

      %w(
        about
        installation
        learning
        resources
        tests
        try
        contribute
        exercises
        help
        launch
        todo
      ).each do |topic|
        define_method topic do
          search_and_replace(read(topic.upcase))
        end
      end

      def better(topic)
        search_and_replace(read('better')).gsub('TOPIC', topic.upcase).gsub('EXT', track.doc_format)
      end

      private

      def read(topic)
        s = File.read(File.absolute_path(File.join("..", "md", "track", "%s.md" % topic), __FILE__))
      end

      def search_and_replace(s)
        substitutions.each do |placeholder, replacement|
          s = s.gsub(placeholder, replacement.to_s)
        end
        s
      end

      def substitutions
        {
          'LANGUAGE' => track.language,
          'TRACK_ID' => track.id,
          'REPO' => track.repository,
          'CHECKLIST_ISSUE' => track.checklist_issue,
        }
      end
    end
  end
end

module X
  module Docs
    class Track < SimpleDelegator
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
        search_and_replace(read('better')).gsub('FILENAME', Trackler::DocFile.find(basename: topic.upcase, track_dir: dir).name)
      end

      private

      def read(topic)
        s = File.read(File.absolute_path(File.join("..", "md", "track", "%s.md" % topic.upcase), __FILE__))
      end

      def search_and_replace(s)
        substitutions.each do |placeholder, replacement|
          s = s.gsub(placeholder, replacement.to_s)
        end
        s
      end

      def substitutions
        {
          'LANGUAGE' => language,
          'TRACK_ID' => id,
          'REPO' => repository,
          'CHECKLIST_ISSUE' => checklist_issue,
        }
      end
    end
  end
end

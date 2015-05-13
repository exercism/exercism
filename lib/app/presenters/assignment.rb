require 'exercism/problem'

module ExercismWeb
  module Presenters
    class Assignment
      Testfile = Struct.new(:filename, :content) do
        def self.collection_from_json(hash)
          hash.collect do |filename, content|
            new(filename, content)
          end
        end

        def extension
          File.extname(filename)[1..-1]
        end

        def testfile?
          filename =~ /test/i ||
            filename =~ /\.t$/ ||
            filename =~ /ut_.*#\.plsql\Z/
        end
      end

      def self.from_json_data(data)
        assignment, * = data.fetch('assignments')
        track = assignment.fetch('track')
        slug = assignment.fetch('slug')
        raw_files = assignment.fetch('files')

        new(track, slug, raw_files)
      end

      def initialize(track, slug, raw_files)
        @track = track
        @slug = slug
        @raw_files = raw_files
      end

      def files
        @files ||= Testfile.collection_from_json(@raw_files)
      end

      def testfiles
        files.select(&:testfile?)
      end

      def problem
        Problem.new(@track, @slug)
      end

      def to_locals
        {problem: problem, testfiles: testfiles}
      end
    end
  end
end

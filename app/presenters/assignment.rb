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
            filename =~ /spec/i ||
            filename =~ /\.t$/ ||
            filename =~ /ut_.*#\.plsql\Z/
        end

        def readme_file?
          filename == 'README.md'
        end
      end

      def self.from_json_data(data)
        exercise, * = data.fetch('problems')
        track_id = exercise.fetch('track_id')
        slug = exercise.fetch('slug')
        raw_files = exercise.fetch('files')

        new(track_id, slug, raw_files)
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

      def readme_file
        files.find(&:readme_file?) ||
          Testfile.new('README.md', 'This exercise has no readme.')
      end

      def problem
        Problem.new(@track, @slug)
      end

      def to_locals
        {
          problem: problem,
          testfiles: testfiles,
          readme_file: readme_file,
        }
      end
    end
  end
end

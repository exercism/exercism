module API
  module Assignments
    class Restore
      attr_reader :submitted, :curriculum

      def initialize(submitted, curriculum)
        @submitted = submitted
        @curriculum = curriculum
      end

      def assignments
        curriculum.languages.inject([]) do |exercises, language|
          exercises + assignment_in(language)
        end
      end

      private

      def assignment_in(language)
        [*submitted_in(language), upcoming_in(language)].compact.map do |slug, code, filename|
          curriculum.in(language).assign(slug, code, filename)
        end
      end

      def upcoming_in(language)
        submitted_slugs = submitted_in(language).map { |slug, code, filename| slug }
        curriculum.in(language).upcoming(submitted_slugs)
      end

      def submitted_in(language)
        submitted.select {|lang, _| lang == language.to_s}.map {|lang, slug, code, filename| [slug, code, filename]}
      end

    end
  end
end

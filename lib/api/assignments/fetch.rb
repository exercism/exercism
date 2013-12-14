module API
  module Assignments
    class Fetch
      attr_reader :completed, :current, :curriculum

      def initialize(completed, current, curriculum)
        @completed = completed
        @current = current
        @curriculum = curriculum
      end

      def assignments
        curriculum.languages.inject([]) do |exercises, language|
          exercises + assignments_in(language)
        end
      end

      private

      def assignments_in(language)
        [*current_in(language), upcoming_in(language)].compact.map do |slug|
          curriculum.in(language).assign(slug)
        end
      end

      def upcoming_in(language)
        curriculum.in(language).upcoming current_in(language) + completed_in(language)
      end

      def current_in(language)
        current.select {|lang, slug| lang == language.to_s}.map {|lang, slug| slug}
      end

      def completed_in(language)
        completed.select {|lang, slug| lang == language.to_s}.map {|lang, slug| slug}
      end
    end
  end
end

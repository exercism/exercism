module App
  module Help
    class Setup
      attr_reader :name

      def initialize(language)
        @name = language
      end

      def not_found?
        !(current? || coming_soon?)
      end

      def topic
        if not_found?
          '404'
        elsif coming_soon?
          'coming-soon'
        else
          slug
        end
      end

      private

      def slug
        name.downcase
      end

      def current?
        Exercism.languages.include?(slug.to_sym)
      end

      def coming_soon?
        Exercism.upcoming.map {|lang| lang.downcase.tr(' ', '-') }.include?(slug)
      end
    end
  end
end

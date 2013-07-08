class Exercism
  class ClojureCurriculum
    def slugs
      %w(
        kindergarden-garden queen-attack robot-simulator
      )
    end

    def locale
      Locale.new('clojure', 'clj', 'clj')
    end
  end
end

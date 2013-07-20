class Exercism
  class ClojureCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count rna-transcription
        robot-name leap triangle scrabble-score
        crypto-square kindergarden-garden robot-simulator queen-attack
      )
    end

    def locale
      Locale.new('clojure', 'clj', 'clj')
    end
  end
end

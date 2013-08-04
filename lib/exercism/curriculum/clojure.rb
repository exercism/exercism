class Exercism
  class ClojureCurriculum
    def slugs
      %w(
        bob rna-transcription word-count anagram beer-song
        nucleotide-count point-mutations phone-number
        grade-school robot-name leap etl meetup space-age grains
        gigasecond triangle scrabble-score
        crypto-square kindergarden-garden robot-simulator queen-attack
      )
    end

    def locale
      Locale.new('clojure', 'clj', 'clj')
    end
  end
end

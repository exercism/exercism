class Exercism
  class ClojureCurriculum
    def slugs
      %w(
        bob rna-transcription word-count anagram beer-song
        nucleotide-count point-mutations phone-number
        grade-school robot-name leap etl meetup space-age grains
        gigasecond triangle scrabble-score roman-numerals
        binary prime-factors raindrops allergies
        atbash-cipher
        crypto-square kindergarten-garden robot-simulator queen-attack
      )
    end

    def locale
      Locale.new('clojure', 'clj', 'clj')
    end
  end
end

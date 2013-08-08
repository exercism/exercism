class Exercism
  class JavascriptCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school robot-name leap etl space-age grains
        gigasecond triangle scrabble-score roman-numerals
        binary prime-factors raindrops allergies strain
        atbash-cipher accumulate crypto-square trinary
        sieve simple-cipher octal luhn pig-latin
        meetup
      )
      # always put meetup last. It's crazy in javascript.
    end

    def locale
      Locale.new('javascript', 'js', 'spec.js')
    end
  end
end

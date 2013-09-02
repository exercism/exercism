class Exercism
  class RubyCurriculum
    def slugs
      %w(
        bob word-count anagram
        nucleotide-count point-mutations phone-number
        grade-school robot-name leap etl meetup space-age grains
        gigasecond triangle scrabble-score roman-numerals
        binary prime-factors raindrops allergies strain
        atbash-cipher accumulate crypto-square trinary rna-transcription
        sieve simple-cipher octal luhn pig-latin pythagorean-triplet
        series difference-of-squares secret-handshake linked-list wordy
        hexadecimal largest-series-product kindergarten-garden
        binary-search-tree matrix robot-simulator nth-prime
        palindrome-products pascals-triangle say beer-song
        sum-of-multiples queen-attack saddle-points ocr-numbers
        simple-linked-list linked-list
      )
    end

    def locale
      Locale.new('ruby', 'rb', 'rb')
    end
  end
end

class Exercism
  class HaskellCurriculum
    def slugs
      %w(
        bob rna-transcription word-count anagram beer-song
        nucleotide-count point-mutations phone-number
        grade-school robot-name leap etl meetup space-age grains
        gigasecond triangle scrabble-score roman-numerals
        binary prime-factors raindrops allergies
        atbash-cipher
        crypto-square kindergarten-garden robot-simulator queen-attack
        accumulate binary-search-tree difference-of-squares hexadecimal
        largest-series-product luhn matrix ocr-numbers octal trinary
        wordy simple-linked-list linked-list nth-prime palindrome-products
        pascals-triangle pig-latin pythagorean-triplet saddle-points say
        secret-handshake series sieve simple-cipher strain sum-of-multiples
      )
    end

    def locale
      Locale.new('haskell', 'hs', 'hs')
    end
  end
end

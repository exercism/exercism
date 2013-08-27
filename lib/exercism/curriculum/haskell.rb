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
        crypto-square kindergarden-garden robot-simulator queen-attack
        accumulate binary-search-tree difference-of-squares hexadecimal
        largest-series-product luhn matrix ocr-numbers octal
      )
    end

    def locale
      Locale.new('haskell', 'hs', 'hs')
    end
  end
end

class Exercism
  class ElixirCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school leap etl meetup space-age grains
        gigasecond triangle scrabble-score roman-numerals
        binary prime-factors raindrops allergies
        atbash-cipher bank-account parallel-letter-frequency
      )
    end

    def locale
      Locale.new('elixir', 'exs', 'exs')
    end
  end
end

class Exercism
  class ElixirCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school leap etl meetup space-age grains
        gigasecond
      )
    end

    def locale
      Locale.new('elixir', 'exs', 'exs')
    end
  end
end

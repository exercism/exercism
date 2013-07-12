class Exercism
  class ElixirCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school leap etl space-age
      )
    end

    def locale
      Locale.new('elixir', 'exs', 'exs')
    end
  end
end

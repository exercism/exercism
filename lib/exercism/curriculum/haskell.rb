class Exercism
  class HaskellCurriculum
    def slugs
      %w(
        bob rna-transcription word-count anagram beer-song
        nucleotide-count point-mutations
      )
    end

    def locale
      Locale.new('haskell', 'hs', 'hs')
    end
  end
end

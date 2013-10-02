class Exercism
  class GoCurriculum
    def slugs
      %w(
        bob word-count anagram nucleotide-count
        binary
      )
    end

    def locale
      Locale.new('go', 'go', 'go')
    end
  end
end

class Exercism
  class ScalaCurriculum
    def slugs
      %w(
        bob hamming word-count anagram
        nucleotide-count phone-number
        grade-school robot-name leap etl
      )
    end

    def locale
      Locale.new('scala', 'scala', 'scala')
    end
  end
end

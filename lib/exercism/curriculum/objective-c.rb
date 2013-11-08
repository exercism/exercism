class Exercism
  class ObjectivecCurriculum
    def slugs
      %w(
        bob hamming word-count anagram
        nucleotide-count phone-number
        grade-school robot-name leap etl
      )
    end

    def locale
      Locale.new('objective-c', 'm', 'm')
    end
  end
end

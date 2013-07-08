class Exercism
  class JavascriptCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school
      )
    end

    def locale
      Locale.new('javascript', 'js', 'spec.js')
    end
  end
end

class Exercism
  class JavascriptCurriculum
    def slugs
      %w(
        bob word-count anagram beer-song nucleotide-count
        rna-transcription point-mutations phone-number
        grade-school
      )
      # always put meetup last. It's crazy in javascript.
    end

    def locale
      Locale.new('javascript', 'js', 'spec.js')
    end
  end
end

class Exercism
  class PythonCurriculum
    def slugs
      %w(
          bob rna-transcription word-count anagram beer-song nucleotide-count
          point-mutations phone-number grade-school
      )
    end

    def locale
      Locale.new('python', 'py', 'py')
    end
  end
end

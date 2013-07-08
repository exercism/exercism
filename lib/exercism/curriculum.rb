class Exercism
  class UnknownLanguage < StandardError; end
end

class Curriculum

  attr_reader :path, :trails, :locales
  def initialize(path)
    @path = path
    @locales = []
    @trails = {}
  end

  def add(curriculum)
    @trails[curriculum.locale.to_sym] = Trail.new(curriculum.locale, curriculum.slugs, path)
    @locales << curriculum.locale
  end

  def in(language)
    trails[language.to_sym]
  end

  def assign(exercise)
    self.in(exercise.language).assign(exercise.slug)
  end

  def identify_language(filename)
    ext = filename.gsub(/\A[^\.]+\./,  '')
    locale = locales.find {|lang| lang.code_extension == ext}
    if locale
      locale.language
    else
      raise Exercism::UnknownLanguage.new("Uknown language for file extension #{ext}")
    end
  end

  def unstarted_trails(started)
    available_languages - started
  end

  def available?(language)
    available_languages.include?(language)
  end

  private

  def available_languages
    locales.map(&:language)
  end

end

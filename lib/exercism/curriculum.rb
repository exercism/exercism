class UnknownLanguage < RuntimeError; end
class Curriculum

  attr_reader :path, :trails, :locales
  def initialize(path)
    @path = path
    @locales = []
    @trails = {}
  end

  def add(locale, slugs)
    @trails[locale.to_sym] = Trail.new(locale, slugs, path)
    @locales << locale
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
      raise UnknownLanguage.new("Uknown language for file extension #{ext}")
    end
  end

  def unstarted_trails(started)
    available_languages - started
  end

  private

  def available_languages
    locales.map(&:language)
  end

end

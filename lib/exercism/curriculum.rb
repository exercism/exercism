class UnknownLanguage < RuntimeError; end
class Curriculum

  attr_reader :path, :trails, :languages
  def initialize(path)
    @path = path
    @languages = []
    @trails = {}
  end

  def add(language, slugs)
    @trails[language.to_sym] = Trail.new(language, slugs, path)
    @languages << language
  end

  def in(language)
    trails[language.to_sym]
  end

  def assign(exercise)
    self.in(exercise.language).assign(exercise.slug)
  end

  def identify_language(filename)
    ext = filename.gsub(/\A[^\.]+\./,  '')
    lang = languages.find {|lang| lang.code_extension == ext}
    if lang
      lang.name
    else
      raise UnknownLanguage.new("Uknown language for file extension #{ext}")
    end
  end

end

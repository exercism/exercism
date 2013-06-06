class Curriculum

  attr_reader :path, :trails
  def initialize(path)
    @path = path
    @trails = {}
  end

  def add(language, slugs)
    @trails[language.to_sym] = Trail.new(language, slugs, path)
  end

  def in(language)
    trails[language.to_sym]
  end

end

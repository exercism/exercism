class Assignment

  attr_reader :path
  def initialize(language, slug, path)
    @path = File.join(path, language.to_s, slug)
  end

end

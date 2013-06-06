class Trail

  attr_reader :exercises, :language, :path
  def initialize(language, slugs, path)
    @language = language
    @exercises = slugs.map {|slug| Exercise.new(language.to_s, slug)}
    @path = path
  end

  def find(slug)
    exercises.find {|ex| ex.slug == slug}
  end

  def assign(slug)
    Assignment.new(language, slug, path)
  end

end

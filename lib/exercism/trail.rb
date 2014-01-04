class Trail

  attr_reader :exercises, :language, :path, :slugs, :name
  def initialize(language, slugs, path)
    @slugs = slugs
    @name = language
    @language = language.downcase.gsub(" ", "-")
    @exercises = slugs.map {|slug| Exercise.new(@language, slug)}
    @path = path
  end

  def find(slug)
    exercises.find {|ex| ex.slug == slug}
  end

  def assign(slug, code=nil, filename=nil)
    Assignment.new(language, slug, path, code, filename)
  end

  def first_assignment
    assign(exercises.first.slug)
  end

  def after(exercise, completed = [])
    exercises.find do |ex|
      !completed.include?(ex.slug)
    end
  end

  def upcoming(completed)
    slugs.find do |slug|
      !completed.include?(slug)
    end
  end

end

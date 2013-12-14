class Trail

  attr_reader :exercises, :language, :path, :slugs
  def initialize(language, slugs, path)
    @slugs = slugs
    @language = language
    @exercises = slugs.map {|slug| Exercise.new(language, slug)}
    @path = path
  end

  def find(slug)
    exercises.find {|ex| ex.slug == slug}
  end

  def assign(slug)
    Assignment.new(language, slug, path)
  end

  def first_assignment
    assign(exercises.first.slug)
  end

  def after(exercise, completed = [])
    exercises.find do |ex|
      !completed.include?(ex.slug)
    end
  end

end

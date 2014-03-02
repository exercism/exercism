class Trail
  attr_reader :exercises, :slugs, :language

  def initialize(language, slugs)
    @slugs = slugs
    @language = language.downcase.gsub(" ", "-")
    @exercises = slugs.map {|slug| Exercise.new(@language, slug)}
  end
end

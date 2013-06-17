class CompletedExercise

  attr_reader :language
  def initialize(language)
    @language = language
  end

  def slug
    'congratulations'
  end

end

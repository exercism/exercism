module ProblemSet
  def doing?(language)
    current.key?(language)
  end

  def did?(language)
    completed.key?(language)
  end

  def current_exercises
    @current_exercises ||= current.map {|language, slug|
      Exercise.new(language, slug)
    }
  end

  def completed_exercises
    return @completed_exercises if @completed_exercises

    exercises = Hash.new {|history, language| history[language] = []}
    completed.each {|language, slugs|
      exercises[language] = slugs.map {|slug|
        Exercise.new(language, slug)
      }
    }
    @completed_exercises = exercises
  end

  def completed?(candidate)
    completed_exercises.any? {|_, exercises| exercises.include?(candidate)}
  end

  def working_on?(candidate)
    current_exercises.any? {|exercise| exercise == candidate}
  end

  def current_languages
    current.keys
  end

  def current_in(language)
    current_exercises.find {|exercise| exercise.in?(language)}
  end

  def latest_in(language)
    completed_exercises[language].last
  end
end

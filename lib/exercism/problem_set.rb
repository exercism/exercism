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
    @completed_exercises ||= begin
      exercises = Hash.new {|history, language| history[language] = []}
      completed.each do |language, slugs|
        exercises[language] = slugs.map do |slug|
          Exercise.new(language, slug)
        end
      end
      exercises
    end
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

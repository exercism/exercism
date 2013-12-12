module ProblemSet
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

  def current_in(language)
    current_exercises.find {|exercise| exercise.in?(language)}
  end

  def latest_in(language)
    completed_exercises[language].last
  end
end

class Exercism
  class UnavailableExercise < StandardError; end
end

class Solution
  attr_reader :user, :code
  def initialize(user, code)
    @user, @code = user, code
  end

  def exercise
    @exercise ||= begin
      Exercise.new(language, slug).tap do |exercise|
        validate exercise
      end
    end
  end

  private

  def slug
    code.slug || user.current_in(language).slug
  end

  def language
    code.language
  end

  def available?(exercise)
    current = user.current_in(exercise.language)
    !current || current.slug == exercise.slug || user.completed?(exercise)
  end

  def validate(candidate)
    unless available?(candidate)
      raise Exercism::UnavailableExercise.new(error_message(candidate))
    end
  end

  def error_message(candidate)
    "#{candidate} has not been unlocked for you yet. You may only submit exercises that you've previously completed, or which are listed as current in your exercism account."
  end
end

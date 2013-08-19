class Exercism
  class UnavailableExercise < StandardError; end
end

class Solution
  attr_reader :user, :code
  def initialize(user, code)
    @user, @code = user, code
  end

  def exercise
    return @exercise if @exercise
    exercise = Exercise.new(code.language, code.slug)
    validate exercise
    @exercise = exercise
  end

  private

  def validate(candidate)
    unless user.working_on?(candidate) || user.completed?(candidate)
      raise Exercism::UnavailableExercise.new(error_message(candidate))
    end
  end

  def error_message(candidate)
    "#{candidate} has not been unlocked for you yet. You may only submit exercises that you've previously completed, or which are listed as current in your exercism account."
  end
end

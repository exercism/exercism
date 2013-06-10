class Assignments

  attr_reader :key
  def initialize(key)
    @key = key
  end

  def user
    @user ||= User.find_by(key: key)
  end

  def current
    @current ||= assigned_exercises
  end

  private

  def assigned_exercises
    user.current_exercises.map do |exercise|
      Exercism.current_curriculum.assign(exercise)
    end
  end
end

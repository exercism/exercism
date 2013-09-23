class Assignments

  attr_reader :key, :curriculum
  def initialize(key, curriculum = Exercism.current_curriculum)
    @key = key
    @curriculum = curriculum
  end

  def user
    @user ||= User.where(key: key).first
  end

  def current
    @current ||= assigned_exercises
  end

  def next
    @next ||= upcoming_exercises
  end

  def completed
    @available ||= completed_exercises
  end

  private

  def assigned_exercises
    Exercism.trails.map do |trail|
      user.current_in(trail.language) || next_on(trail)
    end.compact.map do |exercise|
      curriculum.assign(exercise)
    end
  end

  def next_on(trail)
    latest_exercise = user.latest_in(trail.language)
    slugs = user.completed[trail.language] || []
    trail.after(latest_exercise, slugs)
  end

  def upcoming_exercises
    Exercism.trails.map do |trail|
      current_exercise = user.current_in(trail.language)
      exercise = current_exercise || user.latest_in(trail.language)
      slugs = user.completed[trail.language] || []
      slugs << current_exercise.slug if current_exercise
      upcoming = trail.after(exercise, slugs)
      curriculum.assign(upcoming) if upcoming
    end.compact
  end

  def completed_exercises
    user.done.map do |exercise|
      curriculum.assign(exercise).slug
    end
  end
end

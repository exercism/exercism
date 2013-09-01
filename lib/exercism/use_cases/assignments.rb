class Assignments

  attr_reader :key, :curriculum
  def initialize(key, curriculum = Exercism.current_curriculum)
    @key = key
    @curriculum = curriculum
  end

  def user
    @user ||= User.find_by(key: key)
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
      user.current_in(trail.language) || trail.first
    end.map do |exercise|
      unless exercise.slug == 'congratulations'
        curriculum.assign(exercise)
      end
    end.compact
  end

  def upcoming_exercises
    user.current_exercises.map do |exercise|
      next if exercise.slug == 'congratulations'
      exercise = curriculum.in(exercise.language).successor(exercise)
      next if exercise.slug == 'congratulations'
      curriculum.assign(exercise)
    end.compact
  end

  def completed_exercises
    user.done.map do |exercise|
      curriculum.assign(exercise).slug
    end
  end
end

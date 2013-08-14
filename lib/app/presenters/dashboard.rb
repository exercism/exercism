class Dashboard
  attr_reader :user, :language, :exercise
  def initialize(user)
    @user = user
  end

  def in(language)
    @language = language
    @workload = nil
    self
  end

  def for(exercise)
    @exercise = exercise
    @workload = nil
    self
  end

  def breakdown
    @breakdown ||= Breakdown.of(language)
  end

  def exercises
    return @exercises if @exercises

    if language
      @exercises = exercises_in(language).select {|exercise|
        user.nitpicker_on?(exercise)
      }
    else
      @exercises = []
    end
    @exercises
  end

  def exercises_in(language)
    Exercism.current_curriculum.in(language).exercises
  end

  def submissions
    workload.submissions
  end

  def featured
    workload.featured
  end

  private

  def workload
    @workload ||= Workload.for(user, language, exercise)
  end
end


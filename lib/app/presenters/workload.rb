class NullWorkload
  attr_reader :user, :language, :slug
  def initialize(user, language, slug)
    @user, @language, @slug = user, language, slug
  end

  def breakdown
    {}
  end

  def submissions
    []
  end

  def available_exercises
    []
  end
end

class Workload
  attr_reader :user, :language, :slug
  def initialize(user, language, slug)
    @user = user
    @language = language
    @slug = slug
  end

  def breakdown
    @breakdown ||= pending.group('submissions.slug').count
  end

  def submissions
    return @submissions if @submissions

    scope = pending.order('created_at ASC')
    case slug
    when 'looks-great'
      scope = scope.where(is_liked: true)
    when 'no-nits'
      scope = scope.where(nit_count: 0)
    else
      scope = scope.where(slug: slug)
    end

    unless user.mastery.include?(language)
      scope = scope.where(slug: user.completed[language])
    end

    @submissions = scope.includes(:user)
  end

  def available_exercises
    exercises = Exercism.curriculum.in(language).exercises
    return exercises if user.mastery.include?(language)

    exercises.select {|exercise|
      user.completed[language].include? exercise.slug
    }
  end

  private

  def pending
    @pending ||= Submission.pending.where(language: language).unmuted_for(user)
  end
end

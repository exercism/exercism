class NullWorkload
  attr_reader :user, :language, :slug
  def initialize(user, language, slug)
    @user, @language, @slug = user, language, slug
  end

  def breakdown
    {}
  end

  def show_filters?
    false
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
    Breakdown.of(language)
  end

  def show_filters?
    ![nil, 'no-nits', 'opinions'].include? slug
  end

  def submissions
    return @submissions if @submissions

    scope = pending
    case slug
    when 'looks-great'
      scope = scope.and(is_liked: true)
    when 'opinions'
      scope = scope.and(wants_opinions: true)
    when 'no-nits'
      scope = scope.select {|submission|
        submission.no_nits_yet?
      }
    else
      scope = scope.and(slug: slug)
    end

    submissions = scope.select do |submission|
      show_submission?(user, submission)
    end
    @submissions = submissions
  end

  def available_exercises
    Exercism.current_curriculum.in(language).exercises.select {|exercise|
      user.nitpicker_on?(exercise)
    }
  end

  private

  def pending
    @pending ||= Submission.pending.order(at: :asc).where(language: language)
  end

  def show_submission?(user, submission)
    user.nitpicker_on?(submission.exercise) && !submission.muted_by?(user)
  end
end


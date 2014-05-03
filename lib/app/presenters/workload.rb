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
    when 'needs-input'
      scope = needs_input.order('created_at ASC')
    else
      scope = scope.where(slug: slug)
    end

    unless user.mastery.include?(language)
      scope = scope.where(slug: user.nitpicker[language])
    end

    @submissions = scope.includes(:user)
  end

  def next_submission(current_submission)
    current_index = submissions.index { |submission| submission.id == current_submission.id }
    current_index ? submissions[current_index + 1] : submissions.first
  end

  def available_exercises
    exercises = pending.select('distinct slug').where(language: language).map(&:slug).map {|slug|
      Exercise.new(language, slug)
    }
    return exercises if user.mastery.include?(language)

    exercises.select {|exercise|
      user.nitpicker[language].include? exercise.slug
    }
  end

  private

  def pending
    @pending ||= Submission.pending.where(language: language).where('user_id != ?', user.id).unmuted_for(user)
  end

  def needs_input
    @needs_input ||= Submission.needs_input.where(language: language).where('user_id != ?', user.id).unmuted_for(user)
  end
end

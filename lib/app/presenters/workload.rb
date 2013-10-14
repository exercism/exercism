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
    @breakdown ||= pending.group('submissions.slug').count
  end

  def show_filters?
    ![nil, 'no-nits', 'opinions'].include? slug
  end

  def submissions
    return @submissions if @submissions

    scope = pending.order('created_at ASC')
    case slug
    when 'opinions'
      scope = scope.where(wants_opinions: true)
    when 'looks-great'
      scope = scope.where(is_liked: true)
    when 'no-nits'
      scope = scope.where(nit_count: 0)
    else
      scope = pending.where(slug: slug)
    end

    @submissions = scope.select do |submission|
      user.nitpicker_on?(submission.exercise)
    end
  end

  def available_exercises
    Exercism.current_curriculum.in(language).exercises.select {|exercise|
      user.nitpicker_on?(exercise)
    }
  end

  private

  def pending
    @pending ||= Submission.pending.where(language: language).joins("left join (select submission_id from muted_submissions ms where user_id=#{user.id}) as t ON t.submission_id=submissions.id").where('t.submission_id is null')
  end
end


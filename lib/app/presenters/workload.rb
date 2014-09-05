class NullWorkload
  attr_reader :user, :track_id, :slug
  def initialize(user, track_id, slug)
    @user, @track_id, @slug = user, track_id, slug
  end

  def language
    track_id
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
  attr_reader :user, :track_id, :slug
  def initialize(user, track_id, slug)
    @user = user
    @track_id = track_id
    @slug = slug
  end

  def breakdown
    @breakdown ||= pending.group('submissions.slug').count
  end

  def submissions
    return @submissions if @submissions

    scope = pending.order('created_at ASC')
    no_nits = scope.where(nit_count: 0)

    case slug
    when 'looks-great'
      scope = scope.where(is_liked: true)
    when 'no-nits', 'recent'
      scope = no_nits.since(1.day.ago)
    when 'last-week'
      scope = no_nits.between(1.day.ago, 1.week.ago)
    when 'last-month'
      scope = no_nits.between(1.week.ago, 1.month.ago)
    when 'last-quarter'
      scope = no_nits.between(1.month.ago, 3.months.ago)
    when 'aging'
      scope = no_nits.older_than(3.months.ago)
    when 'needs-input'
      scope = needs_input.order('created_at ASC')
    else
      scope = scope.where(slug: slug)
    end

    unless user.mastery.include?(track_id)
      scope = scope.where(slug: user.nitpicker[track_id])
    end

    @submissions = scope.includes(:user)
  end

  def next_submission(current_submission)
    current_index = submissions.index { |submission| submission.id == current_submission.id }
    current_index ? submissions[current_index + 1] : submissions.first
  end

  def available_exercises
    problems = pending.select('distinct slug').where(language: track_id).map(&:slug).map {|slug|
      Problem.new(track_id, slug)
    }
    return problems if user.mastery.include?(track_id)

    problems.select {|problem|
      user.nitpicker[track_id].include? problem.slug
    }
  end

  private

  def pending
    @pending ||= unmuted_submissions.pending
  end

  def needs_input
    @needs_input ||= unmuted_submissions.needs_input
  end

  def unmuted_submissions
    Submission.excluding(user).unmuted_for(user).for_language(track_id)
  end
end

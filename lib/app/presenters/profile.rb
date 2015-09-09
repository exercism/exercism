class Profile

  def initialize(user, current_user=user)
    @user = user
    @current_user = current_user
  end

  def username
    user.username
  end

  def exercises
    @exercises ||= user.exercises.where(archived: false).where('iteration_count > 0')
  end

  def archived_exercises
    @archived_exercises ||= user.exercises.where(archived: true).where('iteration_count > 0')
  end

  def can_access?(exercise)
    narcissistic? || manager? || current_user.nitpicker_on?(exercise.problem)
  end

  def has_current_exercises?
    exercises.count > 0
  end

  def has_archived_exercises?
    archived_exercises.count > 0
  end

  def teams
    user.unconfirmed_teams | user.teams | user.managed_teams
  end

  def has_teams?
    teams.any?
  end

  def archived_in(track_id)
    archived_exercises.where(language: track_id).reverse
  end

  def track_ids
    @track_ids ||= archived_exercises.pluck('language').uniq
  end

  def submission_link(submission)
    if narcissistic? || manager? || current_user.nitpicker_on?(submission.problem)
     %{<a href="/submissions/#{submission.key}">#{submission.name}&nbsp;<i class="fa fa-star"></i></a>}
    else
     %{<a href="/exercises/#{submission.track_id}/#{submission.slug}">#{submission.name}</a>}
    end
  end

  def narcissistic?
    current_user.is?(user.username)
  end

  def manager?
    !(current_user.managed_teams & user.teams).empty?
  end

  attr_reader :user, :current_user
end

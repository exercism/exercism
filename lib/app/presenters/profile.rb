class Profile

  def initialize(user, current_user=user)
    @user = user
    @current_user = current_user
  end

  def username
    user.username
  end

  def has_current_submissions?
    user.submissions.pending.count > 0
  end

  def has_completed_submissions?
    user.submissions.done.count > 0
  end

  def has_hibernating_submissions?
    user.submissions.hibernating.count > 0
  end

  def teams
    user.unconfirmed_teams | user.teams | user.managed_teams
  end

  def has_teams?
    teams.any?
  end

  def current
    user.active_submissions
  end

  def hibernating_submissions
    user.submissions.hibernating
  end

  def completed_in(track_id)
    user.completed_submissions_in(track_id).reverse
  end

  def track_ids
    @track_ids ||= user.submissions.done.pluck('language').uniq
  end

  def github_link
    %{<a target="_blank" href="https://github.com/#{user.username}">#{user.username}</a>}
  end

  def submission_link(submission)
    if narcissistic? || manager? || current_user.nitpicker_on?(submission.problem)
     %{<a href="/submissions/#{submission.key}">#{submission.name}&nbsp;<i class="fa fa-star"></i></a>}
    else
     %{<a href="/exercises/#{submission.track_id}/#{submission.slug}">#{submission.name}</a>}
    end
  end

  def no_current_submissions_message
    if narcissistic?
      "You have not submitted any exercises lately."
    else
      "#{username} has not submitted any exercises lately."
    end
  end

  def no_completed_submissions_message
    if narcissistic?
      "You have not completed any exercises yet."
    else
      "#{username} has not completed any exercises yet."
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

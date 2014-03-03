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

  def has_nitpicked?
    user.comments.any?
  end

  def nitpicks
    user.comments
  end

  def current
    user.active_submissions
  end

  def hibernating_submissions
    user.submissions.hibernating
  end

  def completed_in(language)
    user.completed_submissions_in(language).reverse
  end

  def languages
    user.worked_in_languages
  end

  def github_link
    %{<a target="_blank" href="https://github.com/#{user.username}">#{user.username}</a>}
  end

  def submission_link(submission)
    if narcissistic? || current_user.nitpicker_on?(submission.exercise)
     %{<a href="/submissions/#{submission.key}">#{submission.name}</a>}
    else
     %{<a href="/exercises/#{submission.language}/#{submission.slug}">#{submission.name}</a>}
    end
  end

  def no_current_sumbissions_message
    if narcissistic?
      "You have not submitted any exercises lately."
    else
      "#{username} has not submitted any exercises lately."
    end
  end

  def no_completed_sumbissions_message
    if narcissistic?
      "You have not completed any exercises yet."
    else
      "#{username} has not completed any exercises yet."
    end
  end

  def narcissistic?
    current_user.is?(user.username)
  end

  attr_reader :user, :current_user

end

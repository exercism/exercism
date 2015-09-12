require 'exercism/xapi'

class Attempt

  attr_reader :user, :code, :track, :slug, :filename, :iteration
  def initialize(user, *stuff)
    @user = user
    @iteration = stuff.last
    @slug = iteration.slug
    @track = iteration.track_id

    # hack
    @code = iteration.solution.values.first
    @filename = iteration.solution.keys.first
  end

  def valid?
    !!slug && Xapi.exists?(track, slug)
  end

  def submission
    @submission ||= Submission.on(problem)
  end

  def problem
    Problem.new(track, slug)
  end

  def save
    submission.solution = iteration.solution
    submission.code = code
    submission.filename = filename
    user.submissions << submission
    user.save
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    submission.reload.viewed_by(user)
    self
  end

  def duplicate?
    !code.empty? && previous_submission.code == code
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(problem).reject {|s| s == submission}
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(problem)
  end

  class InvalidAttemptError < StandardError; end
end


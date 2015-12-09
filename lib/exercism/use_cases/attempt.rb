require 'exercism/xapi'

class Attempt

  attr_reader :user, :track, :slug, :iteration, :submission
  def initialize(user, *stuff)
    @user = user
    @iteration = stuff.last
    @slug = iteration.slug
    @track = iteration.track_id
    @submission = Submission.on(Problem.new(track, slug))
    submission.solution = iteration.solution
  end

  def valid?
    !!slug && X::Exercise.exists?(track, slug)
  end

  def save
    user.submissions << submission
    user.save
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    submission.reload.viewed_by(user)
    self
  end

  def duplicate?
    !submission.solution.empty? && previous_submission.solution == submission.solution
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(submission.problem).reject {|s| s == submission}
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(submission.problem)
  end

  class InvalidAttemptError < StandardError; end
end


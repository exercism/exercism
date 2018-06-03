class Attempt
  attr_reader :user, :track, :slug, :iteration, :submission, :comment
  def initialize(user, *stuff)
    @user = user
    @iteration = stuff.last
    @slug = iteration.slug
    @track = iteration.track_id
    @comment = iteration.comment
    @submission = Submission.on(Problem.new(track, slug))
    submission.solution = iteration.solution
  end

  def save
    user.submissions << submission
    submission.comments.create(user: user, body: comment) if comment.present?

    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    submission.reload.viewed_by(user)
    self
  end

  def duplicate?
    !submission.solution.empty? && previous_submission.solution == submission.solution
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(submission.problem).reject { |s| s == submission }
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(submission.problem)
  end
end

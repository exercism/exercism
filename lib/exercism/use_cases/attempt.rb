class Attempt
  attr_reader :user, :track, :slug, :iteration, :submission, :comment
  # rubocop:disable Metrics/AbcSize
  def initialize(user, *stuff)
    @user = user
    @iteration = stuff.last
    @slug = iteration.slug
    @track = iteration.track_id
    @comment = iteration.comment
    @submission = Submission.on(Problem.new(track, slug))
    submission.solution = iteration.solution
  end
  # rubocop:enable Metrics/AbcSize

  # rubocop:disable Metrics/AbcSize
  def save
    user.submissions << submission
    submission.comments.create(user: user, body: comment) if comment.present?

    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    submission.reload.viewed_by(user)
    self
  end
  # rubocop:enable Metrics/AbcSize

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

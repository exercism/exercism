class Completion

  attr_reader :submission
  def initialize(submission)
    @submission = submission.user_exercise.submissions.last
  end

  def user
    submission.user
  end

  def save
    supersede_old_submissions
    submission.state = 'done'
    submission.done_at = Time.now.utc
    submission.save
    user.reload
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    self
  end

  private

  def supersede_old_submissions
    submission.user_exercise.submissions[0...-1].each do |old_submission|
      old_submission.state = 'superseded'
      old_submission.save
    end
  end
end

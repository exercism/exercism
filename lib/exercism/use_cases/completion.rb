class Completion

  attr_reader :submission, :curriculum
  def initialize(submission, curriculum = Exercism.curriculum)
    @submission = submission.user_exercise.submissions.last
    @curriculum = curriculum
  end

  def user
    submission.user
  end

  def exercise
    submission.exercise
  end

  def trail
    curriculum.in(submission.language)
  end

  def save
    submission.state = 'done'
    submission.done_at = Time.now.utc
    submission.save
    user.reload
    Hack::UpdatesUserExercise.new(submission.user_id, submission.language, submission.slug).update
    self
  end
end

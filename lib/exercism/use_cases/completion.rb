class Completion

  attr_reader :submission, :curriculum
  def initialize(submission, curriculum = Exercism.current_curriculum)
    @submission = submission.related_submissions.last
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
    user.complete! exercise, on: trail
    user.reload
  end
end

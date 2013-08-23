class Completion

  attr_reader :submission, :curriculum
  def initialize(submission, curriculum = Exercism.current_curriculum)
    @submission = submission
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
    submission.state = 'approved'
    submission.approved_at = Time.now.utc
    submission.save
    user.complete! exercise, on: trail
  end
end

class Approval

  attr_reader :id, :approver, :comment, :curriculum
  def initialize(id, approver, comment = nil, curriculum = Exercism.current_curriculum)
    @id = id
    @approver = approver
    @comment = comment
    @curriculum = curriculum
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def submitter
    @submitter ||= submission.user
  end

  def exercise
    @exercise ||= submitter.current_on(submission.language)
  end

  def trail
    @trail ||= curriculum.in(submission.language)
  end

  def save
    submission.state = 'approved'
    submission.approved_at = Time.now.utc
    submission.approved_by = approver.github_id
    submission.approval_comment = comment
    submission.user.complete! exercise, on: trail
    submission.save
    self
  end
end

class Approval

  include InputSanitation

  attr_reader :id, :approver, :comment, :curriculum
  def initialize(id, approver, comment = nil, curriculum = Exercism.current_curriculum)
    @id = id
    @approver = approver
    @comment = sanitize(comment)
    @curriculum = curriculum
  end

  def has_comment?
    comment && !comment.empty?
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def submitter
    @submitter ||= submission.user
  end

  def exercise
    @exercise ||= submitter.current_in(submission.language)
  end

  def trail
    @trail ||= curriculum.in(submission.language)
  end

  def save
    submission.state = 'approved'
    submission.approved_at = Time.now.utc
    submission.approver = approver
    if has_comment?
      submission.nits << Nit.new(user: approver, comment: comment)
    end
    submission.user.complete! exercise, on: trail
    submission.save
    self
  end
end

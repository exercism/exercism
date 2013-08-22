class Approval

  include InputSanitation

  attr_reader :id, :approver, :body, :curriculum
  def initialize(id, approver, body = nil, curriculum = Exercism.current_curriculum)
    @id = id
    @approver = approver
    @body = sanitize(body)
    @curriculum = curriculum
  end

  def has_comment?
    body && !body.empty?
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
      submission.comments << Comment.new(user: approver, comment: body)
    end
    submission.user.complete! exercise, on: trail
    submission.save
    self
  end
end

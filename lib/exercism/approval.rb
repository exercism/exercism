class Approval

  attr_reader :id, :approver, :curriculum
  def initialize(id, approver, curriculum)
    @id = id
    @approver = approver
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

  def save
    submission.approved!(approver, curriculum.in(submission.language))
  end

end

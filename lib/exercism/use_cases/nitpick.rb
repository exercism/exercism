class Nitpick

  attr_reader :id, :nitpicker, :comment
  def initialize(submission_id, nitpicker, comment, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @comment = comment.to_s
    @approvable = options.fetch(:approvable) { false }
    @nitpicked = false
  end

  def nitpicked?
    @nitpicked
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    return self if comment.empty?
    submission.nits << Nit.new(user: nitpicker, comment: comment)
    @nitpicked = true
    if @approvable
      # Total hack.
      # I don't think we will need this once we have notifications
      submission.is_approvable = true
      submission.flagged_by << nitpicker.username
    end
    submission.save
    self
  end
end

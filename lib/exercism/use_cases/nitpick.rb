class Nitpick

  attr_reader :id, :nitpicker, :comment
  def initialize(submission_id, nitpicker, comment, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @comment = comment
    @approvable = options.fetch(:approvable) { false }
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    submission.nits << Nit.new(user: nitpicker, comment: comment)
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

class Nitpick

  include InputSanitation

  attr_reader :id, :nitpicker, :comment
  def initialize(submission_id, nitpicker, comment, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @comment = sanitize(comment.to_s)
    @approvable = options.fetch(:approvable) { false }
    @nitpicked = false
  end

  def nitpicked?
    @nitpicked
  end

  def approvable?
    @approvable
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    unless comment.empty?
      @nitpicked = true
      submission.nits << Nit.new(user: nitpicker, comment: comment)
    end
    if @approvable
      # Total hack.
      submission.is_approvable = true
      submission.flagged_by << nitpicker.username
    end
    submission.save
    self
  end
end

class Nitpick

  include InputSanitation

  attr_reader :id, :nitpicker, :body
  def initialize(submission_id, nitpicker, body, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @body = sanitize(body.to_s)
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
    unless body.empty?
      @nitpicked = true
      submission.comments << Comment.new(user: nitpicker, comment: body)
      submission.state = 'pending' if submission.hibernating?
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

class Nitpick

  include InputSanitation

  attr_reader :id, :nitpicker, :body
  def initialize(submission_id, nitpicker, body, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @body = sanitize(body.to_s)
    @nitpicked = false
  end

  def nitpicked?
    @nitpicked
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    unless body.empty?
      @nitpicked = true
      submission.comments << Comment.new(user: nitpicker, comment: body)
      submission.state = 'pending' if submission.hibernating?
      submission.mute(nitpicker)
      submission.save
    end
    self
  end
end

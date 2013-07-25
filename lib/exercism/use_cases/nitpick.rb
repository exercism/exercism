class Nitpick

  attr_reader :id, :nitpicker, :comment
  def initialize(submission_id, nitpicker, comment)
    @id = submission_id
    @nitpicker = nitpicker
    @comment = comment.to_s
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    unless comment.empty?
      submission.nits << Nit.new(user: nitpicker, comment: comment)
      submission.save
    end
    self
  end
end

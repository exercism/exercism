class CreatesComment

  attr_reader :id, :commenter, :body, :comment

  def self.create(*args)
    commenter = new(*args)
    commenter.create
    commenter.comment
  end

  def initialize(submission_id, commenter, body, options = {})
    @id = submission_id
    @commenter = commenter
    @body = body.to_s
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def create
    @comment = submission.comments.create(user: commenter, body: body)
    unless @comment.new_record?
      @nitpicked = true
      submission.state = 'pending' if submission.hibernating?
      submission.mute(commenter)
      submission.save
    end
  end
end

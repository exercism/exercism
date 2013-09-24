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
    unless body.empty?
      @nitpicked = true
      @comment = Comment.new(user: commenter, body: body)
      submission.comments << @comment
      submission.state = 'pending' if submission.hibernating?
      submission.mute(commenter)
      submission.save
    end
  end
end

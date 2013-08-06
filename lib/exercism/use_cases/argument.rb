class Argument

  include InputSanitation

  attr_reader :submission_id, :nit_id, :comment_id, :comment, :user
  def initialize(data)
    @submission_id = data[:submission_id]
    @nit_id = data[:nit_id]
    @comment_id = data[:comment_id]
    @comment = sanitize(data[:comment])
    @user = data[:user]
  end

  def save
    nit.comments << Comment.new(user: user, body: comment)
    nit.save
    self
  end

  def submission
    @submission ||= Submission.where(id: submission_id).first
  end

  def nit
    @nit ||= submission.nits.where(id: nit_id).first
  end

  def comment
    @comment ||= nit.comments.where(id: comment_id).first
  end
end

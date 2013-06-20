class Argument

  attr_reader :submission_id, :nit_id, :comment, :user
  def initialize(data)
    @submission_id = data[:submission_id]
    @nit_id = data[:nit_id]
    @comment = data[:comment]
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
end

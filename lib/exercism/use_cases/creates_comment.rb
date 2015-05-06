class CreatesComment

  attr_reader :id, :commenter, :body, :comment

  def self.create(*args)
    obj = new(*args)
    obj.create
    obj.comment
  end

  def initialize(submission_id, commenter, body, _ = {})
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
      submission.unmute_all!
      submission.user_exercise.reopen! if submission.hibernating?
      submission.mute(commenter)
      unless submission.user == commenter
        submission.nit_count += 1
      end
      submission.save
    end
  end
end

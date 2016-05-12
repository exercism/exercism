class CreatesComment
  attr_reader :id, :commenter, :body, :comment

  def self.create(*args)
    obj = new(*args)
    obj.create
    obj.comment
  end

  def initialize(submission_id, commenter, body, _={})
    @id = submission_id
    @commenter = commenter
    @body = body.to_s
  end

  def submission
    @submission ||= Submission.find(id)
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @comment = submission.comments.create(user: commenter, body: body)
    unless @comment.new_record?
      exercise = submission.user_exercise
      if exercise.present? # FIXME: only a problem in tests
        submission.viewed_by(commenter)
        exercise.update_last_activity(@comment)
        exercise.save
      end
      submission.save
    end
  end
  # rubocop:enable Metrics/AbcSize
end

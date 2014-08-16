class CommentMessage < Message

  def subject
    "Your #{problem.name} exercise in #{problem.language} got a new comment"
  end

  def template_name
    'comment'
  end

  def submission
    @target.submission
  end

  def nitpick
    @target.body
  end

end

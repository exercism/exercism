class CommentMessage < Message

  def subject
    "Your #{exercise.language} #{exercise.slug} exercise got a new comment"
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

class CommentMessage < Message

  def subject
    "New comment from #{from}"
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

class CommentMessage < Message

  def subject
    "New comment from #{from}"
  end

  def template_name
    'comment'
  end

end

class HibernationMessage < Message

  def subject
    "Your #{exercise.language} #{exercise.slug} submission went into hibernation"
  end

  def template_name
    'hibernation'
  end

  def user_commented_last?
    submission.comments.last.user == submission.user
  end

end

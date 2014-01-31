class HibernationMessage < Message

  def url
    "http://#{site_root}/submissions/#{submission.key}"
  end

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

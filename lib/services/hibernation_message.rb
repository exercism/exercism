class HibernationMessage < Message

  def url
    "#{site_root}/submissions/#{submission.key}"
  end

  def subject
    "Your #{problem.track_id} #{problem.slug} submission went into hibernation"
  end

  def template_name
    'hibernation'
  end

  def user_commented_last?
    submission.comments.last.user == submission.user
  end

end

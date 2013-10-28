class HibernationMessage < Message

  def subject
    "Your #{exercise.language} #{exercise.slug} submission went into hibernation"
  end

  def template_name
    'hibernation'
  end

end

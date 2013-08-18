class HibernationMessage < Message

  def subject
    "Your #{exercise.language} #{exercise.slug} submission went into hibernation"
  end

  def template_name
    'hibernation'
  end

  def from_email
    'katrina.owen@gmail.com'
  end

end

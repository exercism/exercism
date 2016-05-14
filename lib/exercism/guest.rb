class Guest
  def id
  end

  def fetched?
    false
  end

  def onboarded?
    false
  end

  def onboarding_steps
    []
  end

  def exercises
    UserExercise.where('1=2')
  end

  def guest?
    true
  end

  def owns?(_)
    false
  end

  def show_dailies?
    false
  end

  def submissions_per_language
    nil
  end
end

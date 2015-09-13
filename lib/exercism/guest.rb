class Guest
  def id
  end

  def onboarded?
    false
  end

  def onboarding_steps
    []
  end

  def guest?
    true
  end

  def owns?(_)
    false
  end
end

class Guest
  def guest?
    true
  end

  def new?
    false
  end

  def nitpicker?
    false
  end

  def admin?
    false
  end

  def may_nitpick?(submission)
    false
  end
end

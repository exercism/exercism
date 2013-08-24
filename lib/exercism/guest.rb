class Guest
  def guest?
    true
  end

  def locksmith?
    false
  end

  def is?(username)
    false
  end

  def new?
    false
  end

  def nitpicker?
    false
  end

  def may_nitpick?(submission)
    false
  end
end

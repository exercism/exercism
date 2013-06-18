class Guest
  def guest?
    true
  end

  def admin?
    false
  end

  def may_nitpick?(submission)
    false
  end
end

require 'exercism/user_exercise'

class Guest
  def id
  end

  def username
    'guest'
  end

  def fetched?
    false
  end

  def onboarded?
    false
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

  def access?(_)
    false
  end
end

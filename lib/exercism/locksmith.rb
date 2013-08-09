module Locksmith
  def unlocks?(exercise)
    mastered?(exercise) || journeyed?(exercise) || apprenticed?(exercise)
  end

  def mastered?(exercise)
    mastery.include?(exercise.language)
  end

  def journeyed?(exercise)
    journeymans_ticket.include?(exercise.language) && completed?(exercise)
  end

  def apprenticed?(exercise)
    apprenticeship[exercise.language] && apprenticeship[exercise.language].include?(exercise.slug)
  end
end

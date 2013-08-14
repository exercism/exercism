module Locksmith
  def unlocks?(exercise)
    mastered?(exercise) || journeyed?(exercise) || apprenticed?(exercise)
  end

  def master?
    !mastery.empty?
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

  def locksmith?
    !(mastery.empty? && journeymans_ticket.empty? && apprenticeship.empty?)
  end

  def locksmith_in?(language)
    mastery.include?(language) || journeymans_ticket.include?(language) || apprenticeship.has_key?(language)
  end
end

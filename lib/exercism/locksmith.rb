module Locksmith
  def locksmith?
    !mastery.empty?
  end

  def locksmith_in?(language)
    mastery.include?(language)
  end
end

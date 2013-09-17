require 'delegate'
class NullSubmission < SimpleDelegator
  def liked?
    false
  end

  def participants
    []
  end

  def code
    ''
  end
end

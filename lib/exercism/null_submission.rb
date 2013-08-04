require 'delegate'
class NullSubmission < SimpleDelegator

  def submitted?
    false
  end

  def participants
    []
  end
end

require 'delegate'
class NullSubmission < SimpleDelegator
  def approvable?
    false
  end

  def submitted?
    false
  end

  def participants
    []
  end
end

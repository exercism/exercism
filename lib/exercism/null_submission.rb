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

  def code
    ''
  end
end

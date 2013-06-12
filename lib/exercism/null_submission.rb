require 'delegate'
class NullSubmission < SimpleDelegator

  def submitted?
    false
  end
end

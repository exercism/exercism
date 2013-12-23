require 'delegate'
class NullSubmission < SimpleDelegator
  def liked?
    false
  end

  def code
    ''
  end
end

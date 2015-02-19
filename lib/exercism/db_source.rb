class DbSource
  attr_reader :submission

  def initialize(submission)
    @submission = submission
  end

  #we can use delegate method as well
  def solution
    submission.solution
  end
end
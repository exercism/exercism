class Unsubmit
  class SubmissionHasNits  < StandardError; end
  class SubmissionDone     < StandardError; end
  class SubmissionTooOld   < StandardError; end
  class NothingToUnsubmit  < StandardError; end

  TIMEOUT = 5.minutes

  def initialize(user)
    @user = user
  end

  def unsubmit
    submission = @user.most_recent_submission

    raise NothingToUnsubmit.new  if submission.nil?
    raise SubmissionHasNits.new  if submission.this_version_has_nits?
    raise SubmissionDone.new     if submission.done?
    raise SubmissionTooOld.new   if submission.older_than?(TIMEOUT)

    submission.destroy
  end
end

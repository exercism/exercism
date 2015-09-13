class Unsubmit
  class SubmissionHasNits  < StandardError; end
  class SubmissionDone     < StandardError; end
  class SubmissionTooOld   < StandardError; end
  class NothingToUnsubmit  < StandardError; end

  TIMEOUT = 6.hours

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def unsubmit
    submission = user.submissions.order("created_at ASC").last

    raise NothingToUnsubmit.new  if submission.nil?
    raise SubmissionHasNits.new  if submission.nit_count > 0
    raise SubmissionTooOld.new   if submission.older_than?(TIMEOUT)

    submission.destroy
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
  end
end

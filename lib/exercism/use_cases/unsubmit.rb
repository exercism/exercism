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
    submission = user.most_recent_submission

    raise NothingToUnsubmit.new  if submission.nil?
    raise SubmissionHasNits.new  if submission.nit_count > 0
    raise SubmissionDone.new     if submission.done?
    raise SubmissionTooOld.new   if submission.older_than?(TIMEOUT)

    options = {
      user_id: @user,
      language: submission.track_id,
      slug: submission.slug,
      version: submission.version - 1
    }
    previous_submission = Submission.reversed.where(options).limit(1).first

    unless previous_submission.nil?
      previous_submission.state = 'pending'
      previous_submission.save
    end
    submission.destroy
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
  end
end

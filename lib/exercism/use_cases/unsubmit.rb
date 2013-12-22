class Unsubmit
  class SubmissionHasNits  < StandardError; end
  class SubmissionDone     < StandardError; end
  class SubmissionTooOld   < StandardError; end
  class NothingToUnsubmit  < StandardError; end

  TIMEOUT = 5.minutes

  attr_reader :user
  def initialize(user)
    @user = user
  end

  def unsubmit
    submission = user.most_recent_submission

    raise NothingToUnsubmit.new  if submission.nil?
    raise SubmissionHasNits.new  if submission.this_version_has_nits?
    raise SubmissionDone.new     if submission.done?
    raise SubmissionTooOld.new   if submission.older_than?(TIMEOUT)

    options = {
      user_id: @user,
      language: submission.language,
      slug: submission.slug,
      version: submission.version - 1
    }
    previous_submission = Submission.where(options).first

    unless previous_submission.nil?
      previous_submission.state = 'pending'
      previous_submission.save
    end
    submission.destroy
    Hack::UpdatesUserExercise.new(submission.user_id, submission.language, submission.slug).update
  end
end

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
    previous_version_num = submission.version - 1
    previous_submission = Submission.where({ user_id: @user,
                                             language: submission.language,
                                             slug: submission.slug,
                                             version: previous_version_num }).first

    unless previous_submission.nil?
      previous_submission.state = 'pending'
      previous_submission.save
    end

    raise NothingToUnsubmit.new  if submission.nil?
    raise SubmissionHasNits.new  if submission.this_version_has_nits?
    raise SubmissionDone.new     if submission.done?
    raise SubmissionTooOld.new   if submission.older_than?(TIMEOUT)

    submission.destroy
  end
end

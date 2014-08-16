require 'exercism/xapi'

class Attempt

  attr_reader :user, :code, :file
  def initialize(user, code, path)
    @user = user
    @code = sanitize(code)
    @file = Code.new(path)
  end

  def valid?
    !!slug && Xapi.exists?(track, slug)
  end

  def track
    file.track
  end

  def slug
    file.slug
  end

  def submission
    @submission ||= Submission.on(problem)
  end

  def problem
    Problem.new(track, slug)
  end

  def save
    user.submissions_on(problem).each do |sub|
      sub.supersede!
      sub.unmute_all!
    end
    remove_from_completed(problem)
    submission.code = code
    submission.filename = file.filename
    user.submissions << submission
    user.save
    Hack::UpdatesUserExercise.new(submission.user_id, submission.track_id, submission.slug).update
    self
  end

  def remove_from_completed(problem)
    (user.completed[problem.track_id] || []).delete(problem.slug)
  end

  def duplicate?
    previous_submission.code == code
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(problem).reject {|s| s == submission}
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(problem)
  end

  private

  def sanitize(code)
    code.gsub(/\n*\z|\A\n*/, "")
  end

end


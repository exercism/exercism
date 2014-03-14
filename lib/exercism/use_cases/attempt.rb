class Attempt

  attr_reader :user, :code, :file
  def initialize(user, code, path)
    @user = user
    @code = sanitize(code)
    @file = Code.new(path)
  end

  def valid?
    !!slug
  end

  def language
    file.language
  end

  def slug
    file.slug
  end

  def exercise
    @exercise ||= Exercise.new(language, slug)
  end

  def submission
    @submission ||= Submission.on(exercise)
  end

  def save
    return false if slug.nil?
    user.submissions_on(exercise).each do |sub|
      sub.supersede!
      sub.unmute_all!
    end
    remove_from_completed(exercise)
    submission.code = code
    submission.filename = file.filename
    user.submissions << submission
    user.save
    Hack::UpdatesUserExercise.new(submission.user_id, submission.language, submission.slug).update
    self
  end

  def remove_from_completed(exercise)
    (user.completed[exercise.language] || []).delete(exercise.slug)
  end

  def duplicate?
    previous_submission.code == code
  end

  def previous_submissions
    @previous_submissions ||= user.submissions_on(exercise).reject {|s| s == submission}
  end

  def previous_submission
    @previous_submission ||= previous_submissions.first || NullSubmission.new(exercise)
  end

  private

  def sanitize(code)
    code.gsub(/\n*\z|\A\n*/, "")
  end

end


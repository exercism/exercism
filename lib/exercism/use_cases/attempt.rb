class Attempt

  attr_reader :user, :code, :language
  def initialize(user, code, filename, curriculum = Exercism.current_curriculum)
    @user = user
    @code = sanitize(code)
    @language = curriculum.identify_language(filename)
  end

  def on_started_trail?
    !!user.current[language]
  end

  def submission
    @submission ||= Submission.on(exercise)
  end

  def save
    user.submissions_on(exercise).each do |sub|
      sub.supersede!
    end
    submission.code = code
    if previous_submission.approvable?
      submission.is_approvable = true
    end
    user.submissions << submission
    user.save
    self
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

  def exercise
    @exercise ||= user.current_on(language)
  end

  def sanitize(code)
    code.gsub(/\n*\z/, "")
  end

end


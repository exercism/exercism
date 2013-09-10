class Exercism
  class UnknownExercise < StandardError; end
end

class Attempt

  attr_reader :user, :code, :file, :curriculum
  def initialize(user, code, path, curriculum = Exercism.current_curriculum)
    @user = user
    @code = sanitize(code)
    @file = Code.new(path, curriculum.locales)
    @curriculum = curriculum
  end

  def language
    file.language
  end

  def slug
    file.slug || user.current[language]
  end

  def submission
    @submission ||= Submission.on(exercise)
  end

  def save
    unless user.completed?(exercise)
      user.do! exercise
    end
    user.submissions_on(exercise).each do |sub|
      sub.supersede!
      sub.unmute_all!
    end
    if user.completed?(exercise)
      submission.state = 'tweaked'
    end
    user.clear_stash(file.path)
    submission.code = code
    user.submissions << submission
    user.save
    self
  end

  def validate!
    unless curriculum.in(language).find(slug)
      raise Exercism::UnknownExercise.new("Unknown exercise '#{slug}' in #{language}")
    end
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

  def exercise
    @exercise ||= solution.exercise
  end

  private

  def solution
    @solution ||= Solution.new(user, file)
  end

  def sanitize(code)
    code.gsub(/\n*\z/, "")
  end

end


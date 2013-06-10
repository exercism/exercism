class Attempt

  attr_reader :user, :code, :language
  def initialize(user, code, filename, curriculum)
    @user = user
    @code = code
    @language = curriculum.identify_language(filename)
  end

  def save
    user.submissions_on(exercise).each do |sub|
      sub.supercede!
    end
    submission = Submission.on(exercise)
    submission.code = code
    user.submissions << submission
    user.save
  end

  private

  def exercise
    @exercise ||= user.current_on(language)
  end

end


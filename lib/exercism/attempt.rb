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
    user.submissions << Submission.on(exercise)
    user.save
  end

  private

  def exercise
    @exercise ||= user.current_on(language)
  end

end


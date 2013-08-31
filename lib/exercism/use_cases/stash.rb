class Stash

  attr_reader :user, :code
  def initialize(user, code, filename, curriculum = Exercism.current_curriculum)
    @user = user
    @code = code
    @file = Code.new(filename, curriculum.locales)
  end

  def filename
    @file.filename
  end

  def language
    @file.language
  end

  def submission
    @submission ||= Submission.new
  end

  def save
    user.submissions.each do |sub|
      sub.supersede! if sub.stash_name == filename
    end
    submission.state = 'stashed'
    submission.code = code
    submission.stash_name = filename
    user.submissions << submission
    user.save
    self
  end

  def find
    user.stashed_submissions.select{ |sub| sub.stash_name == filename}.first
  end

end

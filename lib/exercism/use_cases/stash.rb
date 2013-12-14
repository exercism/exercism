class Stash

  attr_reader :user, :code, :file
  def initialize(user, code, filename)
    @user = user
    @code = code
    @file = Code.new(filename)
  end

  def filename
    file.path
  end

  def submission
    @submission ||= Submission.new(
      language: file.language,
      slug: file.slug,
      state: 'stashed',
      code: code,
      stash_name: filename
    )
  end

  def save
    user.submissions.each do |sub|
      sub.supersede! if sub.stash_name == filename
    end
    user.submissions << submission
    user.save
    self
  end

  def find
    user.stashed_submissions.select{ |sub| sub.stash_name == filename}.first
  end

end

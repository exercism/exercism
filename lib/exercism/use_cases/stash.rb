class Stash 

  attr_reader :user, :code, :filename, :language
  def initialize(user, code, filename, curriculum = Exercism.current_curriculum)
    @user = user
    @code = code
    @filename = filename
    @language = curriculum.identify_language(@filename)
  end

  def submission
  	@submission ||= Submission.new
  end

  def save
    user.submissions.each do |sub|
      sub.supersede! if sub.stash_name == self.filename
    end
    submission.state = 'stashed'
    submission.code = code
    submission.stash_name = filename
  	user.submissions << submission
    user.save
  	self
  end

  def find
    user.stashed_submissions.select{ |sub| sub.stash_name == self.filename}.first
  end

end
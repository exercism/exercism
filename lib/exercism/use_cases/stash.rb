class Stash 

  attr_reader :user, :code, :language
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
    old = self.get_stash
    if old
      old.delete
    end
  	submission.state = 'stashed'
  	self.add_title
  	user.submissions << submission
    user.save
  	self
  end

  def loot
    submission = self.get_stash
    self
  end

  def get_stash
    user.submissions.select{ |submission| submission.stashed? }[0]
  end

  def add_title
    submission.code = @filename + " " + code
  end

  private

  def exercise
    @exercise ||= user.current_on(language)
  end

end
class Mute

  attr_reader :submission, :user, :site_root
  def initialize(submission, user, site_root = 'http://exercism.io')
    @submission = submission
    @user = user
    @site_root = site_root
  end

  def save
    submission.muted_by << user
    submission.save
  end
end

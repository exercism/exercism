class Mute

  attr_reader :submission, :user, :site_root
  def initialize(submission, user, site_root = 'http://exercism.io')
    @submission = submission
    @user = user
    @site_root = site_root
  end

  def save
    if submission.pending?
      submission.muted_by << user
    end
    submission.save
  end
end

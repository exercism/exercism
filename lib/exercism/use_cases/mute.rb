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
      hibernate! if hibernate?
    end
    submission.save
  end

  private

  def hibernate?
    has_nits? && locksmith? && stale?
  end

  def hibernate!
    submission.state = 'hibernating'
    Notify.source(submission, 'hibernating')
    begin
      HibernationMessage.ship(
        instigator: user,
        submission: submission,
        site_root: site_root
      )
    rescue => e
      puts "Failed to send email. #{e.message}."
    end
  end

  def has_nits?
    submission.nits_by_others_count > 0
  end

  def locksmith?
    user.locksmith?
  end

  def stale?
    latest_nit_at <= a_week_ago
  end

  def a_week_ago
    Time.now - (60 * 60 * 24 * 7)
  end

  def latest_nit_at
    submission.nits_by_others.map(&:created_at).sort.last
  end
end

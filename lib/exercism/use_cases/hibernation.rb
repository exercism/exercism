class Hibernation
  WINDOW = 60 * 60 * 24 * 7 * 3

  def self.admin
    @admin ||= User.find_by_username('kytrinyx')
  end

  attr_reader :submission
  def initialize(submission, intercept=nil)
    @submission = submission
    @intercept = intercept == :intercept
  end

  def process
    if stale?
      hibernate and notify
    end
  end

  private

  def cutoff
    Time.now - Hibernation::WINDOW
  end

  def hibernate
    submission.state = 'hibernating'
    submission.save
  end

  def notify
    Notify.source(submission, 'hibernating')
    begin
      HibernationMessage.ship(
        instigator: Hibernation.admin,
        target: submission,
        site_root: 'http://exercism.io',
        intercept_emails: @intercept
      )
    rescue => e
      puts "Unable to email #{submission.user.username}. #{e}."
    end
  end

  def stale?
    submission.comments.last.created_at < cutoff
  end
end


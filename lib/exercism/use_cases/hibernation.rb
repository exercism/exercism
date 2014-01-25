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
      Hack::UpdatesUserExercise.new(submission.user_id, submission.language, submission.slug).update
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
    alert_submitter
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

  def comment
    submission.comments.last
  end

  def stale?
    comment.user != submission.user && comment.created_at < cutoff
  end

  def alert_submitter
    attributes = {
      user_id: submission.user_id,
      read: false,
      url: ['', submission.user.username, submission.user_exercise.key].join('/'),
      link_text: "View submission.",
      text: "Your exercise #{submission.slug} in #{submission.language} has gone into hibernation."
    }
    Alert.create(attributes)
  end
end


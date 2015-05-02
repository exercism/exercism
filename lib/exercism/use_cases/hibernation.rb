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
    if qualifies_for_hibernation?
      hibernate and notify
    end

    if qualifies_for_needing_input?
      needs_input
    end

    update_user_exercise
  end

  def update_user_exercise
    Hack::UpdatesUserExercise.new(
        submission.user_id,
        submission.track_id,
        submission.slug
    ).update
  end

  private

  def cutoff
    Time.now - Hibernation::WINDOW
  end

  def needs_input
    submission.state = 'needs_input'
    submission.save
  end

  def hibernate
    submission.state = 'hibernating'
    submission.save
  end

  def notify
    attributes = {
      user_id: submission.user_id,
      read: false,
      url: ['', submission.user.username, submission.user_exercise.key].join('/'),
      link_text: "View submission.",
      text: "Your exercise #{submission.slug} in #{submission.track_id} has gone into hibernation."
    }
    Alert.create(attributes)
  end

  def comment
    submission.comments.last
  end

  def qualifies_for_needing_input?
    last_commenter_is_submitter? && stale_comment?
  end

  def qualifies_for_hibernation?
    !last_commenter_is_submitter? && stale_comment?
  end

  def stale_comment?
    comment.created_at < cutoff
  end

  def last_commenter_is_submitter?
    comment.user == submission.user
  end
end


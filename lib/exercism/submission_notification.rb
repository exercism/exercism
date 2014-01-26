require 'exercism/notification'

class SubmissionNotification < Notification

  belongs_to :submission, foreign_key: 'item_id'

  scope :joins_submissions, -> { joins('INNER JOIN submissions s ON s.id = notifications.item_id') }
  scope :personal, -> { joins_submissions.where('s.user_id = notifications.user_id') }
  scope :general, -> { joins_submissions.where('s.user_id != notifications.user_id') }

  def nitpick?
    regarding == 'nitpick'
  end

  def done?
    regarding == 'done'
  end

  def like?
    regarding == 'like'
  end

  def username
    submission.user.username
  end

  def language
    submission.language
  end

  def slug
    submission.slug
  end

  def link
    "/submissions/#{submission.key}"
  end
end


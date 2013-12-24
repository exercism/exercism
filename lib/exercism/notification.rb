class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission

  scope :by_recency, -> { order("created_at DESC") }
  scope :recent, -> { by_recency.limit(400) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :joins_submissions, -> { joins('INNER JOIN submissions s ON s.id=notifications.submission_id') }
  scope :personal, -> { joins_submissions.where('s.user_id = notifications.user_id') }
  scope :general, -> { joins_submissions.where('s.user_id != notifications.user_id') }

  before_create do
    self.read  ||= false
    self.count ||= 0
    true
  end

  def self.viewed!(submission, user)
    where(submission_id: submission.id, user_id: user.id).update_all(read: true)
  end

  def self.on(submission, options)
    data = {
      submission_id: submission.id,
      user_id: options.fetch(:to).id,
      regarding: options[:regarding]
    }
    notification = where(data.merge(read: false)).first || new(data)
    notification.increment
    notification.save
    notification
  end

  def self.mark_read(user, id)
    where(user: user).and(_id: id).first.tap do |notification|
      notification.update_attributes(read: true)
    end
  end

  def state
    read ? 'read' : 'unread'
  end

  def custom?
    regarding == 'custom'
  end

  def nitpick?
    regarding == 'nitpick'
  end

  def done?
    regarding == 'done'
  end

  def like?
    regarding == 'like'
  end

  def hibernating?
    regarding == 'hibernating'
  end

  def recipient
    user
  end

  def username
    submission.user.username if submission
  end

  def increment
    self.count += 1
  end

  def read!
    self.read = true
    save
  end

  def language
    submission.language if submission
  end

  def slug
    submission.slug if submission
  end

  def link
    "/submissions/#{submission.key}" unless custom?
  end

  def icon
    case regarding
    when "hibernating"
      "moon"
    when "custom"
      "info-sign"
    when "like"
      "thumbs-up"
    when "attempt"
      "code"
    else
      s = "comment"
      s << "s" if count > 1
      s << "-alt" if submission && submission.user != recipient
      s
    end
  end
end


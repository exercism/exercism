class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission

  scope :recent, -> { order("created_at DESC").limit(100) }

  before_create do
    self.read  ||= false
    self.count ||= 0
    true
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
end


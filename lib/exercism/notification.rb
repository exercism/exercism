class Notification
  include Mongoid::Document

  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :count, type: Integer, default: 0
  field :n, as: :note, type: String # only for custom notifications

  belongs_to :user
  belongs_to :submission

  def self.recent_for_user(user)
    where(user: user).limit(100).descending(:at)
  end

  def self.on(submission, options)
    data = {
      submission: submission,
      user: options.fetch(:to),
      regarding: options[:regarding]
    }
    notification = where(data.merge(read: false)).first || new(data)
    notification.increment
    notification.save
    notification
  end

  def self.mark_read(user, id)
    notification = where(user: user).and(_id: id).first
    notification.update_attributes(read: true)
    notification
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

  def assignment_completed?
    Submission.assignment_completed?(submission) if submission
  end
end


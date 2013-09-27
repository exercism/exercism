class Notification
  include Mongoid::Document

  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :count, type: Integer, default: 0
  field :n, as: :note, type: String # only for custom notifications

  belongs_to :user, index: true
  belongs_to :submission

  scope :recent, desc(:at).limit(100)

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


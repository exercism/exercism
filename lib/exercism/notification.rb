require 'forwardable'
class Notification
  include Mongoid::Document
  extend Forwardable

  field :re, as: :regarding, type: String
  field :r, as: :read, type: Boolean, default: false
  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :count, type: Integer, default: 0

  belongs_to :user
  belongs_to :submission

  def_delegators :submission, :language, :slug

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
    submission.user.username
  end

  def increment
    self.count += 1
  end

  def read!
    self.read = true
    save
  end
end


class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :alert

  scope :about_nitpicks, -> { where(type: 'SubmissionNotification').where(regarding: ['like', 'code', 'nitpick']) }
  scope :by_recency, -> { order("created_at DESC") }
  scope :recent, -> { by_recency.limit(400) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :joins_submissions, -> { joins('INNER JOIN submissions s ON s.id = notifications.item_id') }
  scope :personal, -> { joins_submissions.where('s.user_id = notifications.user_id') }
  scope :general, -> { joins_submissions.where('s.user_id != notifications.user_id') }

  before_create do
    self.read  ||= false
    self.count ||= 0
    true
  end

  def self.viewed!(item, user)
    where(item_id: item.id, user_id: user.id).update_all(read: true)
  end

  def self.on(item, options)
    data = {
      item_id: item.id,
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

  def recipient
    user
  end

  def increment
    self.count += 1
  end

  def read!
    self.read = true
    save
  end

  def icon
    "info-sign"
  end
end


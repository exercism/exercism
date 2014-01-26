class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission, foreign_key: 'item_id'
  belongs_to :item, polymorphic: true

  scope :on_submissions, -> { where(item_type: 'Submission') }
  scope :without_alerts, -> { where(regarding: ['like', 'code', 'nitpick']) }
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
      user_id: options.fetch(:to).id,
      regarding: options[:regarding]
    }
    notification = on_item(item, data)
    if item.is_a?(Submission)
      on_item(item.user_exercise, data)
    else
      on_item(item.submissions.last, data)
    end
    notification
  end

  # Hack. Please ignore.
  def self.on_item(item, data)
    data = data.merge(item_id: item.id, item_type: item.class.to_s)
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
    update_attributes(read: true)
    related_notifications.each do |notification|
      notification.update_attributes(read: true)
    end
  end

  def related_notifications
    if item_type == 'Submission'
      Notification.where(user_id: user.id, item_type: 'UserExercise', item_id: item.user_exercise.id).to_a
    else
      Notification.where(user_id: user.id, item_type: 'Submission', item_id: item.submissions.map(&:id)).to_a
    end
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

  # TODO: delete when v1.0 goes live
  def note
  end
end

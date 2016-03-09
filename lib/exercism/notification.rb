class Notification < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission, foreign_key: 'item_id'
  belongs_to :item, polymorphic: true
  belongs_to :creator, class_name: "User"

  scope :on_submissions, -> { where(item_type: 'Submission') }
  scope :on_exercises, -> { where(item_type: 'UserExercise') }
  scope :by_recency, -> { order("created_at DESC") }
  scope :recent, -> { by_recency.limit(400) }
  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }
  scope :joins_exercises, -> { on_exercises.joins('INNER JOIN user_exercises e ON e.id = notifications.item_id') }
  scope :joins_submissions , -> { on_submissions.joins('INNER JOIN submissions e ON e.id = notifications.item_id') }
  scope :personal, -> {joins_submissions.where('e.user_id = notifications.user_id')}
  scope :general, -> {joins_submissions.where('e.user_id != notifications.user_id')}

  before_create do
    self.read  ||= false
    self.count ||= 0
    self.action = regarding
    self.actor_id = creator_id
    self.iteration_id = item_id if item_type == 'Submission'
    true
  end

  def self.viewed!(item, user)
    type = item.is_a?(Submission) ? 'Submission' : 'UserExercise'
    where(item_id: item.id, item_type: type, user_id: user.id).update_all(read: true)
  end

  def self.on(item, options)
    data = {
      user_id: options.fetch(:to).id,
      regarding: options[:regarding],
      creator_id: options.fetch(:creator).id
    }
    # trigger usual notification
    notification = on_item(item, data)
    # trigger shadow notification
    if item.is_a?(Submission)
      if item.user_exercise
        on_item(item.user_exercise, data)
      end
    else
      unless item.submissions.empty?
        on_item(item.submissions.last, data)
      end
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
    item.user.username
  end

  def language
    item.language
  end

  def slug
    item.slug
  end

  def link
    # only used in API for old notifications
    "/submissions/#{item.key}"
  end

  # TODO: delete when v1.0 goes live
  def note
  end
end

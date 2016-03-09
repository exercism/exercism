class Notification < ActiveRecord::Base
  belongs_to :actor, class_name: "User"
  belongs_to :iteration, class_name: "Submission"

  scope :unread, -> { where(read: false) }
  scope :feedback, -> { joins(:iteration).where('submissions.user_id=notifications.user_id') }
  scope :by_recency, -> { order("created_at DESC") }
  scope :recent, -> { by_recency.limit(400) }

  before_create do
    self.read  ||= false
    self.count ||= 0
    self.action = regarding
    self.actor_id = creator_id
    self.iteration_id = item_id if item_type == 'Submission'
    true
  end

  def self.viewed!(iteration, user)
    where(iteration_id: iteration.id, user_id: user.id).update_all(read: true)
  end

  def self.on(iteration, options)
    data = {
      user_id: options.fetch(:to).id,
      regarding: options[:regarding],
      creator_id: options.fetch(:creator).id,
      item_id: iteration.id,
      item_type: 'Submission',
    }
    notification = where(data.merge(read: false)).first || new(data)
    notification.count += 1
    notification.save
    notification
  end

  # Consider implementing a presenter if we get more display-related stuff.
  def icon
    case action
    when 'like'
      'thumbs-up'
    when 'mention'
      'comments'
    when 'comment', 'nitpick'
      'comment-o'
    when 'iteration', 'code'
      'code'
    else
      'asterisk'
    end
  end

  def whose
    case
    when user_id == iteration.user_id
      'your'
    when actor_id == iteration.user_id
      'their'
    else
      "%s's" % iteration.user.username
    end
  end

  def url
    "/submissions/%s" % iteration.uuid
  end
end

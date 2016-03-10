class Notification < ActiveRecord::Base
  belongs_to :actor, class_name: "User"
  belongs_to :iteration, ->{ includes(:user) }, class_name: "Submission"

  scope :unread, -> { where(read: false) }
  scope :feedback, -> { joins(:iteration).where('submissions.user_id=notifications.user_id') }
  scope :by_recency, -> { order("created_at DESC") }
  scope :recent, -> { by_recency.limit(400) }

  before_create do
    if read.nil?
      self.read = false
    end
    true
  end

  def self.viewed!(iteration, user)
    where(iteration_id: iteration.id, user_id: user.id).update_all(read: true)
  end

  def self.on(iteration, data)
    data = data.merge(iteration_id: iteration.id, solution_id: iteration.user_exercise_id)
    notification = where(data.merge(read: false)).first || new(data)
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
    when 'comment'
      'comment-o'
    when 'iteration'
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

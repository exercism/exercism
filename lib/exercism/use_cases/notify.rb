class Notify
  def self.everyone(iteration, action, actor)
    Participants.in(iteration).uniq(&:id).reject { |user| user.id == actor.id }.each do |user|
      Notification.on(iteration, user_id: user.id, action: action, actor_id: actor.id)
    end
  end

  def self.source(iteration, action, actor)
    Notification.on(iteration, user_id: iteration.user_id, action: action, actor_id: actor.id)
  end
end


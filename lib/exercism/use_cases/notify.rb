class Notify
  def self.everyone(iteration, action, actor)
    ConversationSubscription.subscriber_ids(iteration).each do |id|
      next if id == actor.id
      Notification.on(iteration, user_id: id, action: action, actor_id: actor.id)
    end
  end

  def self.source(iteration, action, actor)
    Notification.on(iteration, user_id: iteration.user_id, action: action, actor_id: actor.id)
  end
end

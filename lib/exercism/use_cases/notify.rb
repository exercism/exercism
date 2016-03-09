class Notify
  def self.everyone(submission, regarding, creator)
    Participants.in(submission).uniq(&:id).reject { |u| u.id == creator.id }.each do |to|
      Notification.on(submission, to: to, regarding: regarding, creator: creator)
    end
  end

  def self.source(submission, regarding, creator)
    Notification.on(submission, to: submission.user, regarding: regarding, creator: creator)
  end
end


class Notify
  def self.everyone(submission, regarding, creator)
    cohort = Cohort.for(submission.user)
    users = cohort.sees(submission.problem) + participants_in(submission) - [creator]
    users.each do |to|
      Notification.on(submission, to: to, regarding: regarding, creator: creator)
    end
  end

  def self.participants_in(submission)
    Participants.in(submission.user_exercise.submissions, submission.id)
  end

  def self.source(submission, regarding, creator)
    Notification.on(submission, to: submission.user, regarding: regarding, creator: creator)
  end
end


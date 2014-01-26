class Notify
  def self.everyone(submission, regarding, options = {})
    except = Array(options[:except])
    cohort = Cohort.for(submission.user)
    users = cohort.sees(submission.exercise) + participants_in(submission) - except
    users.each do |to|
      Notification.on(submission, to: to, regarding: regarding)
    end
  end

  def self.participants_in(submission)
    Participants.in(submission.user_exercise.submissions)
  end

  def self.source(submission, regarding)
    Notification.on(submission, to: submission.user, regarding: regarding)
  end
end


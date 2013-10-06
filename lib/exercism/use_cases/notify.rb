class Notify
  def self.everyone(submission, regarding, options = {})
    except = Array(options[:except])
    cohort = Cohort.for(submission.user)
    users = cohort.sees(submission.exercise) + submission.participants - except
    users.each do |to|
      Notification.on(submission, to: to, regarding: regarding)
    end
  end

  def self.about(note, options)
    data = {
      note: note,
      regarding: 'custom',
      user: options[:to]
    }
    Notification.create(data)
  end

  def self.source(submission, regarding)
    Notification.on(submission, to: submission.user, regarding: regarding)
  end
end


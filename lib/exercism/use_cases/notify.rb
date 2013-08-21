class Notify
  def self.everyone(submission, regarding, options = {})
    except = Array(options[:except])
    (submission.participants - except).each do |to|
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

  def self.source(submission, regarding, options = {})
    except = Array(options[:except])
    unless except.include?(submission.user)
      Notification.on(submission, to: submission.user, regarding: regarding)
    end
  end
end


class Notify
  def self.everyone(submission, from, about)
    (submission.participants - [from]).each do |to|
      new(submission, to, from, about).save
    end
  end

  def self.source(submission, from, about)
    new(submission, submission.user, from, about).save
  end

  attr_reader :submission, :to, :from, :about

  def initialize(submission, to, from, about)
    @submission = submission
    @to = to
    @from = from
    @about = about
  end

  def save
    Notification.create({
      user: to,
      from: from.username,
      regarding: about,
      link: link(about)
    })
  end

  def link(about)
    "/" + send("#{about}_link".to_sym)
  end
  def approval_link
    [
      submission.user.username,
      submission.language,
      submission.slug
    ].join("/")
  end
  alias_method :new_attempt_link, :approval_link

  def nitpick_link
    [
      "submissions",
      submission.id
    ].join("/")
  end
  alias_method :comment_link, :nitpick_link

end

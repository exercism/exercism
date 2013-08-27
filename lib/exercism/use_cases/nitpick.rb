class Nitpick

  include InputSanitation

  attr_reader :id, :nitpicker, :body
  def initialize(submission_id, nitpicker, body, options = {})
    @id = submission_id
    @nitpicker = nitpicker
    @body = sanitize(body.to_s)
    @liked = options.fetch(:liked) { false }
    @nitpicked = false
  end

  def nitpicked?
    @nitpicked
  end

  def liked?
    @liked
  end

  def submission
    @submission ||= Submission.find(id)
  end

  def save
    mute = false
    unless body.empty?
      @nitpicked = true
      submission.comments << Comment.new(user: nitpicker, comment: body)
      submission.state = 'pending' if submission.hibernating?
      mute = true
    end
    if liked?
      submission.is_liked = true
      submission.liked_by << nitpicker.username
      mute = true
    end
    if mute
      submission.mute(nitpicker.username)
    end
    submission.save
    self
  end
end

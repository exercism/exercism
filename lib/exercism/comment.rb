require 'exercism/input_sanitation'
require 'exercism/markdown'

class Comment
  include Mongoid::Document
  include InputSanitation

  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :comment, type: String

  belongs_to :user
  belongs_to :submission

  # Experiment: Implement manual counter-cache
  # to see if this affects load time of dashboard pages.
  # preliminary testing in development suggests a 40% decrease
  # in load time
  after_create do |comment|
    unless comment.user.owns?(comment.submission)
      comment.submission.nc += 1
      comment.submission.save
    end
  end

  def nitpicker
    user
  end

  def mentions
    ExtractsMentionsFromMarkdown.extract(comment)
  end

  def sanitized_update(comment)
    self.comment = sanitize(comment)
    save
  end

end

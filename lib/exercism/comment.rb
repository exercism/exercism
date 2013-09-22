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
    # http://rubular.com/r/TagnENb1Wm
    candidates = html_comment_without_code.scan(/\@\w+/).uniq
    candidates.each_with_object([]) do |username, mentions|
      mentions << User.find_by(:u => username.sub(/\@/, '')) rescue nil
    end
  end

  def sanitized_update(comment)
    self.comment = sanitize(comment)
    save
  end

  private

  def html_comment_without_code
    html_comment = Markdown.render(comment)
    dom = Nokogiri::HTML(html_comment)
    dom.css("code").remove
    dom.css("td[class='code']").remove
    dom.css("body").first.content
  end

end

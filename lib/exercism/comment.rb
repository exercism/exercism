require 'exercism/markdown'

class Comment < ActiveRecord::Base
=begin
  include Mongoid::Document

  field :at, type: Time, default: ->{ Time.now.utc }
  field :c, as: :comment, type: String
  field :hc, as: :html_comment, type: String

  belongs_to :user
  belongs_to :submission
=end

  belongs_to :user
  belongs_to :submission

  before_save do |comment|
    self.html_comment = ConvertsMarkdownToHTML.convert(comment.comment)
  end

  # Experiment: Implement manual counter-cache
  # to see if this affects load time of dashboard pages.
  # preliminary testing in development suggests a 40% decrease
  # in load time
  after_create do |comment|
    unless comment.user.owns?(comment.submission)
      comment.submission.nit_count += 1
      comment.submission.save
    end
  end

  def nitpicker
    user
  end

  def mentions
    ExtractsMentionsFromMarkdown.extract(comment)
  end
end

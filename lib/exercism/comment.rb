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

  before_create do
    self.at ||= DateTime.now.utc
    true
  end

  before_save do
    self.html_body = ConvertsMarkdownToHTML.convert(body)
    true
  end

  # Experiment: Implement manual counter-cache
  # to see if this affects load time of dashboard pages.
  # preliminary testing in development suggests a 40% decrease
  # in load time
  after_create do
    unless user.owns?(submission)
      submission.nit_count += 1
      submission.save
    end
  end

  def nitpicker
    user
  end

  def mentions
    ExtractsMentionsFromMarkdown.extract(body)
  end
end

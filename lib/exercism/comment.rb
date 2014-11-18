require 'exercism/markdown'

class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission

  validates :body, presence: true

  before_save do
    self.html_body = ConvertsMarkdownToHTML.convert(body)
    true
  end

  scope :reversed, ->{ order('created_at DESC') }
  scope :received_by, ->(user) { where(submission_id: user.submissions.pluck(:id)) }
  scope :paginate_by_params, ->(params) { paginate(page: params[:page], per_page: params[:per_page] || 10) }

  def nitpicker
    user
  end

  def submission_user
    submission.user
  end

  def mentions
    ExtractsMentionsFromMarkdown.extract(body)
  end
end

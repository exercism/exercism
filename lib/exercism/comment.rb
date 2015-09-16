require 'exercism/markdown'

class Comment < ActiveRecord::Base

  belongs_to :user
  belongs_to :submission
  has_many :comment_threads

  validates :body, presence: true

  before_save do
    self.html_body = ConvertsMarkdownToHTML.convert(body)
    true
  end

  scope :reversed, ->{ order(created_at: :desc) }
  scope :received_by, ->(user) { where(submission_id: user.submissions.pluck(:id)) }
  scope :paginate_by_params, ->(params) { paginate(page: params[:page], per_page: params[:per_page] || 10) }

  scope :except_on_submissions_by, ->(user) { joins(:submission).merge(Submission.not_submitted_by(user)) }

  def nitpicker
    user
  end

  def activity_description
    return "" if user.nil?

    "@#{user.username} commented"
  end

  def submission_user
    submission.user
  end

  def mentions
    ExtractsMentionsFromMarkdown.extract(body)
  end

  def qualifying?
    submission_user != user
  end

  def increment_five_a_day
    if FiveADayCount.exists?(:user_id => user.id)
      FiveADayCount.where(:user_id => user.id).first.increment!(:total)
    else
      FiveADayCount.create(user_id: user.id, total: 1)
    end
  end
end

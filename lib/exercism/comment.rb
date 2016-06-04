require 'exercism/markdown'
require 'exercism/excerpt'

class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission

  validates :body, presence: true

  before_save do
    self.html_body = ConvertsMarkdownToHTML.convert(body)
    true
  end

  def html_body
    "<span ng-non-bindable>#{super}</span>"
  end

  scope :reversed, -> { order(created_at: :desc) }
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

  def qualifying?
    submission_user != user
  end

  def mention_ids
    @mention_ids ||= User.where(username: mentions).pluck(:id).map(&:to_i)
  end

  def excerpt(length)
    Excerpt.new(html_body).limit(length)
  end

  private

  # rubocop:disable Metrics/AbcSize
  def mentions
    # Don't trust that the HTML has been rendered yet.
    # This will double-render in most cases.
    dom = Nokogiri::HTML(ExercismLib::Markdown.render(body))
    dom.css("code").remove
    dom.css("td[class='code']").remove
    s = dom.css("body").first
    s = !!s ? s.content : ""
    s.scan(/\@(\w+)/).uniq.flatten
  end
  # rubocop:enable Metrics/AbcSize
end

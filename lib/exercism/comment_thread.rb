require 'exercism/markdown'

class CommentThread < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment

  validates :body, :comment_id, :user_id, presence: true

  before_save do
    self.html_body = ConvertsMarkdownToHTML.convert(body)
    true
  end

end

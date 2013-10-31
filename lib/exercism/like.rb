class Like < ActiveRecord::Base

  belongs_to :submission
  belongs_to :user

  validates :submission, presence: true
  validates :user, presence: true

end

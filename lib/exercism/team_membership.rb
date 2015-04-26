class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id

  validates :user, uniqueness: { scope: :team }
  scope :confirmed, ->{ where(confirmed: true) }

  before_create do
    self.confirmed = false
    true
  end

  def confirm!
    self.confirmed = true
    save
  end

end

class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates :user, uniqueness: { scope: :team }

  before_create do
    self.confirmed = false
    true
  end

  def confirm!
    self.confirmed = true
    save
  end

end

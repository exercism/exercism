class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  before_create do
    self.confirmed = false
    true
  end

  def confirm!
    self.confirmed = true
    save
  end

end

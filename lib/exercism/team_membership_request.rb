class TeamMembershipRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  scope :for_team, -> (team_id) { where(team_id: team_id) }

  def accept!
    ActiveRecord::Base.transaction do
      TeamMembership.create!(
        team_id: team_id,
        user_id: user_id,
        confirmed: true
      )

      destroy
    end
  end

  def refuse!
    self.refused = true
    save
  end

  def pending?
    !refused?
  end
end

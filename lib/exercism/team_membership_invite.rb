class TeamMembershipInvite < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id

  scope :for_team, -> (team_id) { where(team_id: team_id) }
  scope :refused, -> { where(refused: true) }
  scope :pending, -> { where(refused: false) }

  def accept!
    ActiveRecord::Base.transaction do
      TeamMembership.create!(
        team_id: team_id,
        user_id: user_id,
        inviter_id: inviter_id,
        confirmed: true
      )

      destroy
    end
  end

  def refuse!
    self.refused = true
    save
  end
end

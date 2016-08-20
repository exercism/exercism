class TeamMembership < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :inviter, class_name: 'User', foreign_key: :inviter_id

  validates :user, uniqueness: { scope: :team }
  scope :for_team, -> (team_id) { where(team_id: team_id) }

  def self.destroy_for_team(id)
    for_team(id).map(&:destroy)
  end
end

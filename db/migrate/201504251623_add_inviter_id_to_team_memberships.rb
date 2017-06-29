class AddInviterIdToTeamMemberships < ActiveRecord::Migration[4.2]
  def change
    add_column :team_memberships, :inviter_id, :integer
  end
end

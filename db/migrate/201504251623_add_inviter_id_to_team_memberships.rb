class AddInviterIdToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :inviter_id, :integer
  end
end

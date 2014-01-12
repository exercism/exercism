class AddConfirmedToTeamMemberships < ActiveRecord::Migration
  def change
    add_column :team_memberships, :confirmed, :boolean
  end
end
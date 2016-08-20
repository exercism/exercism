class CreateTeamMembershipInvitesTable < ActiveRecord::Migration
  def up
    create_table :team_membership_invites do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false
      t.integer :inviter_id
      t.boolean :refused, null: false, default: false
      t.timestamps null: false
    end

    add_index :team_membership_invites, [:team_id, :user_id]
  end

  def down
    drop_table :team_membership_invites
  end
end

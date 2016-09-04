class CreateTeamMembershipRequestsTable < ActiveRecord::Migration
  def up
    create_table :team_membership_requests do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false
      t.boolean :refused, null: false, default: false
      t.timestamps null: false
    end

    add_index :team_membership_requests, [:team_id, :user_id]
  end

  def down
    drop_table :team_membership_requests
  end
end

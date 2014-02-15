class CreateTeamManagers < ActiveRecord::Migration
  def change
    create_table :team_managers do |t|
      t.integer :user_id, null: false
      t.integer :team_id, null: false
    end
  end
end

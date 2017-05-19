class CreateTeamManagers < ActiveRecord::Migration[4.2]
  def change
    create_table :team_managers do |t|
      t.integer :user_id, null: false
      t.integer :team_id, null: false
    end
  end
end

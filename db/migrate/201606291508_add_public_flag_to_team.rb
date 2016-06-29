class AddPublicFlagToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :public, :boolean, default: false
    add_index :teams, [:public]
  end
end

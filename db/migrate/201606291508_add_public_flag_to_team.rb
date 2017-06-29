class AddPublicFlagToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :public, :boolean, default: false
    add_index :teams, [:public]
  end
end

class AddDescriptionToTeam < ActiveRecord::Migration[4.2]
  def change
    add_column :teams, :description, :text
  end
end

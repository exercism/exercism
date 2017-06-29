class DeleteTeamCreator < ActiveRecord::Migration[4.2]
  def change
    remove_column :teams, :creator_id
  end
end

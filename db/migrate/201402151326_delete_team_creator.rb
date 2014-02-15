class DeleteTeamCreator < ActiveRecord::Migration
  def change
    remove_column :teams, :creator_id
  end
end

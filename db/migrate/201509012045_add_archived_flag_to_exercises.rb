class AddArchivedFlagToExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :archived, :boolean, default: false
  end
end

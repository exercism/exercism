class AddArchivedFlagToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :archived, :boolean, default: false
  end
end

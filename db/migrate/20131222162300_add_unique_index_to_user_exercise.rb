class AddUniqueIndexToUserExercise < ActiveRecord::Migration
  def change
    add_index :user_exercises, [:user_id, :language, :slug], unique: true
  end
end

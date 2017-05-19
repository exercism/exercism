class DropCompletedAtFieldFromUserExercises < ActiveRecord::Migration[4.2]
  def up
    remove_column :user_exercises, :completed_at
  end

  def down
    add_column :user_exercises, :completed_at, :timestamp
  end
end

class DropCompletedAtFieldFromUserExercises < ActiveRecord::Migration
  def up
    remove_column :user_exercises, :completed_at
  end

  def down
    add_column :user_exercises, :completed_at, :timestamp
  end
end

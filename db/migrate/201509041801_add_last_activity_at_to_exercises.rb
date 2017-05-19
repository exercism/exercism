class AddLastActivityAtToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :last_activity_at, :timestamp
  end
end

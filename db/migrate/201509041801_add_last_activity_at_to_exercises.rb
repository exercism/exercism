class AddLastActivityAtToExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :last_activity_at, :timestamp
  end
end

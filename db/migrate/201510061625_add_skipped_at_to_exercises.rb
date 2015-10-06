class AddSkippedAtToExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :skipped_at, :timestamp
  end
end

class AddSkippedAtToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :skipped_at, :timestamp
  end
end

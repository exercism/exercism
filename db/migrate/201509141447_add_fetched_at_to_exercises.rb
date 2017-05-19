class AddFetchedAtToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :fetched_at, :timestamp
  end
end

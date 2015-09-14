class AddFetchedAtToExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :fetched_at, :timestamp
  end
end

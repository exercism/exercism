class AddLastIterationAtToExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :last_iteration_at, :timestamp
  end
end

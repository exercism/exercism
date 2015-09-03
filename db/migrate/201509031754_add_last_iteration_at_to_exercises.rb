class AddLastIterationAtToExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :last_iteration_at, :timestamp
  end
end

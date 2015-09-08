class AddLastActivityToExercise < ActiveRecord::Migration
  def change
    add_column :user_exercises, :last_activity, :string
  end
end

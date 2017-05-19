class AddLastActivityToExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :last_activity, :string
  end
end

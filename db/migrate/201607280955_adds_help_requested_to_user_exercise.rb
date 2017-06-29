class AddsHelpRequestedToUserExercise < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :help_requested, :boolean, default: false
  end
end

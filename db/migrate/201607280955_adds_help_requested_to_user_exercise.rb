class AddsHelpRequestedToUserExercise < ActiveRecord::Migration
  def change
    add_column :user_exercises, :help_requested, :boolean, default: false
  end
end

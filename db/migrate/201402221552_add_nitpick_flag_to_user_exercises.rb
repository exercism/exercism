class AddNitpickFlagToUserExercises < ActiveRecord::Migration
  def change
    add_column :user_exercises, :is_nitpicker, :boolean, default: false
  end
end

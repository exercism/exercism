class AddNitpickFlagToUserExercises < ActiveRecord::Migration[4.2]
  def change
    add_column :user_exercises, :is_nitpicker, :boolean, default: false
  end
end

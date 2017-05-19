class DropAclFieldFromUserExercises < ActiveRecord::Migration[4.2]
  def up
    remove_column :user_exercises, :is_nitpicker
  end

  def down
    add_column :user_exercises, :is_nitpicker, :boolean, default: false
  end
end

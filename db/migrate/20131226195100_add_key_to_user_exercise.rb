class AddKeyToUserExercise < ActiveRecord::Migration
  def change
    add_column :user_exercises, :key, :string
    add_index :user_exercises, :key, unique: true
  end
end

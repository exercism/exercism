class AddUserExerciseToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :user_exercise, :integer
    add_index :submissions, :user_exercise
  end
end

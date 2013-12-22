class RenameUserExerciseReferenceOnSubmissions < ActiveRecord::Migration
  def change
    remove_index :submissions, :user_exercise
    rename_column :submissions, :user_exercise, :user_exercise_id
    add_index :submissions, :user_exercise_id
  end
end

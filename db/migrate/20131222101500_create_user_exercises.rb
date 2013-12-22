class CreateUserExercises < ActiveRecord::Migration
  def change
    create_table :user_exercises do |t|
      t.integer   :user_id,       null: false
      t.string    :language
      t.string    :slug
      t.integer   :iteration_count
      t.string    :state
      t.timestamp :completed_at

      t.timestamps
    end

    add_index :user_exercises, :user_id
    add_index :user_exercises, [:language, :slug, :state]
  end
end

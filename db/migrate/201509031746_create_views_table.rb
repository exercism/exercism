class CreateViewsTable < ActiveRecord::Migration
  def change
    create_table :views do |t|
      t.integer  :user_id, null: false
      t.integer  :exercise_id, null: false
      t.timestamp :last_viewed_at, null: false

      t.timestamps null: false
    end

    add_index :views, [:user_id, :exercise_id], unique: true
  end
end

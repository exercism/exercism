class DropMutedSubmissions < ActiveRecord::Migration
  def up
    drop_table :muted_submissions
  end

  def down
    create_table :muted_submissions do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end

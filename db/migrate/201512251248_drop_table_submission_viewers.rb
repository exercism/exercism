class DropTableSubmissionViewers < ActiveRecord::Migration
  def up
    drop_table :submission_viewers
  end

  def down
    create_table :submission_viewers do |t|
      t.integer :submission_id, null: false
      t.integer :viewer_id, null: false

      t.timestamps null: false
    end

    add_index :submission_viewers, [:submission_id, :viewer_id], unique: true, name: 'by_submission'
  end
end

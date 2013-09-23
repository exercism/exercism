class CreateSubmissionViewers < ActiveRecord::Migration
  def change
    create_table :submission_viewers do |t|
      t.integer :submission_id, null: false
      t.integer :viewer_id, null: false
    end
  end
end


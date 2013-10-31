class CreateMutedSubmissions < ActiveRecord::Migration
  def change
    create_table :muted_submissions do |t|
      t.integer :submission_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end

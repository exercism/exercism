class AddIndexSubmissionIdToComments < ActiveRecord::Migration
  def change
    add_index :comments, [:submission_id]
  end
end

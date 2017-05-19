class AddIndexSubmissionIdToComments < ActiveRecord::Migration[4.2]
  def change
    add_index :comments, [:submission_id]
  end
end

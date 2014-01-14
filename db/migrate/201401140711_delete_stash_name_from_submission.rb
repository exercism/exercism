class DeleteStashNameFromSubmission < ActiveRecord::Migration
  def change
    remove_column :submissions, :stash_name
  end
end

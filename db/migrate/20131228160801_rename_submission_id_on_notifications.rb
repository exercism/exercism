class RenameSubmissionIdOnNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :submission_id, :item_id
  end
end

class AddTemporaryAlertColumnToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :alert_id, :integer
    add_index :notifications, :alert_id
  end
end

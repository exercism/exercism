class RemoveTemporaryAlertColumnFromNotifications < ActiveRecord::Migration
  def change
    remove_column :notifications, :alert_id
  end
end

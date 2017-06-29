class AddClientVersionNotificationDismissedAtToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :client_version_update_notification_dismissed_at, :timestamp
  end
end

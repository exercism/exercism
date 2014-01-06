class AddTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :type, :string
  end
end

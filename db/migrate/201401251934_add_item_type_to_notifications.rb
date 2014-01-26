class AddItemTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :item_type, :string
  end
end

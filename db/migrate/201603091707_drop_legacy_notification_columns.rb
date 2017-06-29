class DropLegacyNotificationColumns < ActiveRecord::Migration[4.2]
  def up
    remove_column :notifications, :item_type
    remove_column :notifications, :item_id
    remove_column :notifications, :creator_id
    remove_column :notifications, :count
    remove_column :notifications, :regarding
  end

  def down
    add_column :notifications, :item_type, :string
    add_column :notifications, :item_id, :integer
    add_column :notifications, :creator_id, :integer
    add_column :notifications, :count, :integer
    add_column :notifications, :regarding, :string
  end
end

class DeleteLeftoverFieldsOnNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :item_type
    remove_column :notifications, :note
  end
end

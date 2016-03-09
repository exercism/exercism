class AddColumnsToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :action, :string
    add_column :notifications, :actor_id, :integer
    add_column :notifications, :solution_id, :integer
    add_column :notifications, :iteration_id, :integer
    add_index :notifications, :user_id
  end
end

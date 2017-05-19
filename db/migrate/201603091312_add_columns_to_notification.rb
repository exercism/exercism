class AddColumnsToNotification < ActiveRecord::Migration[4.2]
  def change
    add_column :notifications, :action, :string
    add_column :notifications, :actor_id, :integer
    add_column :notifications, :solution_id, :integer
    add_column :notifications, :iteration_id, :integer
    add_index :notifications, :user_id
  end
end

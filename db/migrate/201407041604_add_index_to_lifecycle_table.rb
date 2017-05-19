class AddIndexToLifecycleTable < ActiveRecord::Migration[4.2]
  def change
    add_index :lifecycle_events, [:user_id, :key]
  end
end

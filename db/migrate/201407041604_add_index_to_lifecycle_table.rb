class AddIndexToLifecycleTable < ActiveRecord::Migration
  def change
    add_index :lifecycle_events, [:user_id, :key]
  end
end

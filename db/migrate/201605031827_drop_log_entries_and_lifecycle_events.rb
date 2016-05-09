class DropLogEntriesAndLifecycleEvents < ActiveRecord::Migration
  def change
    drop_table :lifecycle_events
    drop_table :log_entries
  end
end

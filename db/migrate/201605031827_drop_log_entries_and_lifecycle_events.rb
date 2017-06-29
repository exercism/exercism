class DropLogEntriesAndLifecycleEvents < ActiveRecord::Migration[4.2]
  def change
    drop_table :lifecycle_events
    drop_table :log_entries
  end
end

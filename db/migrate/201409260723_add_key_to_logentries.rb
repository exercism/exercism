class AddKeyToLogentries < ActiveRecord::Migration
  def change
    add_column :log_entries, :key, :string
  end
end

class AddKeyToLogentries < ActiveRecord::Migration[4.2]
  def change
    add_column :log_entries, :key, :string
  end
end

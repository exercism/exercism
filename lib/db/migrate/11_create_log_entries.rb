class CreateLogEntries < ActiveRecord::Migration
  def change
    create_table :log_entries do |t|
      t.integer  :user_id
      t.text     :body
      t.timestamps
    end
  end
end

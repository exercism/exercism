class DropTableAlerts < ActiveRecord::Migration
  def up
    drop_table :alerts
  end

  def down
    create_table :alerts do |t|
      t.integer   :user_id, null: false
      t.text      :text
      t.string    :url
      t.string    :link_text
      t.boolean   :read
      t.timestamps null: false
    end

    add_index :alerts, :user_id
  end
end

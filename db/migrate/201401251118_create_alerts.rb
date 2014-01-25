class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.integer   :user_id,       null: false
      t.text      :text
      t.string    :url
      t.string    :link_text
      t.boolean   :read
      t.timestamps
    end

    add_index :alerts, :user_id
  end
end

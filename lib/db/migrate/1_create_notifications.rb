class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.string   :regarding
      t.boolean  :read
      t.integer  :count,         null: false, default: 0
      t.string   :note

      t.timestamps

      t.string :mongoid_id
      t.string :mongoid_user_id
      t.string :mongoid_submission_id
    end
    add_index :notifications, :mongoid_id, unique: true
    add_index :notifications, :mongoid_user_id
    add_index :notifications, :mongoid_submission_id
  end
end


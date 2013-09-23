class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.string   :regarding
      t.boolean  :read
      t.datetime :at
      t.integer  :count,         null: false, default: 0
      t.string   :note
    end
  end
end


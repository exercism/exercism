class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.text     :body
      t.text     :html_body

      t.timestamps

      t.string :mongoid_id
      t.string :mongoid_user_id
      t.string :mongoid_submission_id
    end
    add_index :comments, :mongoid_id, unique: true
    add_index :comments, :mongoid_user_id
    add_index :comments, :mongoid_submission_id
  end
end

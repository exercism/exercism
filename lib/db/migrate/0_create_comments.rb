class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.text     :body
      t.text     :html_body

      t.timestamps
    end
  end
end

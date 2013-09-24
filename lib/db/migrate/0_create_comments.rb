class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.datetime :at
      t.text     :body
      t.text     :html_body
    end
  end
end

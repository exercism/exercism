class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer  :user_id,       null: false
      t.integer  :submission_id, null: false

      t.datetime :at
      t.text     :comment
      t.text     :html_comment
    end
  end
end

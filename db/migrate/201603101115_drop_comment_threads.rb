class DropCommentThreads < ActiveRecord::Migration
  def up
    drop_table :comment_threads
  end

  def down
    create_table :comment_threads do |t|
      t.integer   :user_id, null: false
      t.integer   :comment_id, null: false

      t.text      :body
      t.text      :html_body

      t.timestamps null: false
    end
  end
end

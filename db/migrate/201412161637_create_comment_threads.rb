class CreateCommentThreads < ActiveRecord::Migration[4.2]
  def change
    create_table :comment_threads do |t|
      t.integer   :user_id, null: false
      t.integer   :comment_id, null: false

      t.text      :body
      t.text      :html_body

      t.timestamps null: false
    end
  end
end

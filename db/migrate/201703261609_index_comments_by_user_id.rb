class IndexCommentsByUserId < ActiveRecord::Migration[4.2]
  def change
    add_index :comments, [:user_id, :updated_at]
  end
end

class IndexCommentsByUserId < ActiveRecord::Migration
  def change
    add_index :comments, [:user_id, :updated_at]
  end
end

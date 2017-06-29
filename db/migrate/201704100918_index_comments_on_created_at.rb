class IndexCommentsOnCreatedAt < ActiveRecord::Migration[4.2]
  def change
    add_index :comments, :created_at
  end
end

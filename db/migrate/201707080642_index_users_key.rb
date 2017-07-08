class IndexUsersKey < ActiveRecord::Migration[5.1]
  def change
    add_index :users, :key
  end
end

class AddIndices < ActiveRecord::Migration
  def change
    add_index :users, :username
    add_index :submissions, :key
  end
end

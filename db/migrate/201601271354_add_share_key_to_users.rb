class AddShareKeyToUsers < ActiveRecord::Migration
  def up
    add_column :users, :share_key, :string
  end

  def down
    remove_column :users, :share_key
  end
end

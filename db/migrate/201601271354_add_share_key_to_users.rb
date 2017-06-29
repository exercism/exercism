class AddShareKeyToUsers < ActiveRecord::Migration[4.2]
  def up
    add_column :users, :share_key, :string
  end

  def down
    remove_column :users, :share_key
  end
end

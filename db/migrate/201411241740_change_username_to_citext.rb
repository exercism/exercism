class ChangeUsernameToCitext < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION citext"
    change_column :users, :username, :citext
  end

  def down
    change_column :users, :username, :string
    execute "DROP EXTENSION citext"
  end
end

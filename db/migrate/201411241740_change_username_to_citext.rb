class ChangeUsernameToCitext < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS citext"
    change_column :users, :username, :citext
  end

  def down
    change_column :users, :username, :string
    execute "DROP EXTENSION IF EXISTS citext"
  end
end

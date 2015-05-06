class ChangeDefaultValueToUserSource < ActiveRecord::Migration
  
  def up
    #execute "CREATE EXTENSION SOURCE TYPE"
    change_column :users, :source_type, :string, :default => "GITHUB"
  end

  def down
   # change_column :users, :username, :string
    change_column :users, :source_type, :string, :default => "DB"
  end
  
 end

class AddSourceTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :source_type, :string, default: 'DB'
  end
end

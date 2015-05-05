class AddSourceTypeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :source_type, :string, default: "GITHUB"
  end
end

class AddApiSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_secret, :string
    add_column :users, :api_key, :string
  end
end

class AddApiSecretToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :api_secret, :string
    add_column :users, :api_key, :string
  end
end

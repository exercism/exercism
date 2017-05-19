class AddProfileToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :joined_as, :string
  end
end

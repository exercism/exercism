class AddProfileToUser < ActiveRecord::Migration
  def change
    add_column :users, :joined_as, :string
  end
end

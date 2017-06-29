class AddOnboardedAtToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :onboarded_at, :timestamp
  end
end

class AddOnboardedAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :onboarded_at, :timestamp
  end
end

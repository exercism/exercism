class DeleteWorkCachesFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :current
    remove_column :users, :completed
  end
end
